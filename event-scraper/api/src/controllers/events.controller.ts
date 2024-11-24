import { Controller, Get, Query, Logger } from '@nestjs/common';
import { ScraperService } from '../services/scraper.service';
import { PocketBaseService } from '../services/pocketbase.service';
import { Event } from '../interfaces/event.interface';

@Controller('api/v1')
export class EventsController {
  private readonly logger = new Logger(EventsController.name);

  constructor(
    private readonly scraperService: ScraperService,
    private readonly pocketBaseService: PocketBaseService,
  ) {}

  @Get('get_events')
  async getEvents(@Query('url') url: string, @Query('restaurant_id') restaurantId: string): Promise<Event[]> {
    try {
      if (!url || !restaurantId) {
        throw new Error('Missing required query parameters: url, restaurant_id');
      }
      if (!url) {
        throw new Error('Missing url required query parameters');
      }
      if (!restaurantId) {
        throw new Error('Missing restaurant_id required query parameters');
      }

      // Scrape events
      const events = await this.scraperService.getEvents(url);

      // Save to PocketBase
      await this.pocketBaseService.saveEvents(events, restaurantId);

      return events;
    } catch (error: unknown) {
      const errorMessage = error instanceof Error ? error.message : 'An unknown error occurred';
      this.logger.error(`Error in get_events endpoint: ${errorMessage}`);
      throw error;
    }
  }
}
