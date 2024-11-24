import { Injectable, Logger } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { Event } from "../interfaces/event.interface";
// eslint-disable-next-line @typescript-eslint/no-require-imports
const PocketBase = require("pocketbase/cjs");
const fetch = require("node-fetch");

@Injectable()
export class PocketBaseService {
  private readonly logger = new Logger(PocketBaseService.name);
  private client: any;

  constructor(private configService: ConfigService) {
    this.initializeClient();
  }

  private async initializeClient() {
    try {
      this.client = new PocketBase(
        this.configService.get<string>("POCKETBASE_URL"),
      );
      await this.authenticate();
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ? error.message : "An unknown error occurred";
      this.logger.error(
        `Failed to initialize PocketBase client: ${errorMessage}`,
      );
      throw error;
    }
  }

  private async authenticate() {
    try {
      await this.client.admins.authWithPassword(
        this.configService.get<string>("POCKETBASE_EMAIL"),
        this.configService.get<string>("POCKETBASE_PASSWORD"),
      );
      this.logger.log("Successfully authenticated with PocketBase");
    } catch (error: unknown) {
      const errorMessage =
        error instanceof Error ? error.message : "An unknown error occurred";
      this.logger.error(
        `Failed to authenticate with PocketBase: ${errorMessage}`,
      );
      throw error;
    }
  }

  private async downloadAndProcessImage(url: string): Promise<FormData | null> {
    try {
      const response = await fetch(url);
      if (!response.ok) {
        this.logger.warn(`Failed to download image from ${url}`);
        return null;
      }

      const buffer = await response.buffer();
      const formData = new FormData();
      const blob = new Blob([buffer], { type: 'image/jpeg' });
      formData.append('thumbnail', blob, 'thumbnail.jpg');
      return formData;
    } catch (error) {
      this.logger.error(`Error processing image: ${error}`);
      return null;
    }
  }

  async saveEvents(events: Event[], restaurantId: string): Promise<void> {
    let currentEvent: any = null;
    try {
      // Wait for client initialization if it hasn't completed
      if (!this.client) {
        await this.initializeClient();
      }

      for (const event of events) {
        let formData = new FormData();
        const pbData = {
          title: `${event.eventName}`,
          start: event.startTime,
          end: event.endTime || '',
          price: event.price?.toString() || '0',
          tickets_available: '100',
          restaurant_id: restaurantId,
          genre: event.genre || '',
          description: event.description || '',
        };
        currentEvent = pbData

        // Convert pbData to FormData
        Object.entries(pbData).forEach(([key, value]) => {
          formData.append(key, value);
        });

        // Handle thumbnail if URL exists
        if (event.thumbnailUrl) {
          const imageFormData = await this.downloadAndProcessImage(event.thumbnailUrl);
          if (imageFormData) {
            // Merge the image FormData with our existing FormData
            formData = new FormData();
            Object.entries(pbData).forEach(([key, value]) => {
              formData.append(key, value);
            });
            formData.append('thumbnail', imageFormData.get('thumbnail'));
          }
        }

        try {
          await this.client.collection("live_events").create(formData);
        }
        catch (error: any) {
          if (error.response?.data?.title?.code === 'validation_not_unique') {
            this.logger.warn(`Failed to save events to PocketBase: Event already exists`);
            continue;
          }
          if (error.response?.data?.thumbnail?.code === 'validation_file_size_limit') {
            this.logger.warn(`Failed to save events to PocketBase: Thumbnail file size too large`);
            continue;
          }
          throw error;
        }
      }

      this.logger.log(
        `Successfully saved ${events.length} events to PocketBase`,
      );
    } catch (error: any) {
      const errorMessage = error.response?.data?.title?.code || error.message || 'Unknown error';
      this.logger.error(`Failed to save events to PocketBase: ${errorMessage}`);
      console.log(currentEvent)
      console.log(error.response?.data)
      throw error;
    }
  }
}
