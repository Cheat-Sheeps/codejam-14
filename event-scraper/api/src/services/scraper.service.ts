import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import OpenAI from 'openai';
import * as cheerio from 'cheerio';
import axios from 'axios';
import { Event } from '../interfaces/event.interface';

@Injectable()
export class ScraperService {
  private readonly logger = new Logger(ScraperService.name);
  private readonly openai: OpenAI;

  constructor(private configService: ConfigService) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('OPENAI_API_KEY'),
    });
  }

  private cleanHtml(html: string): string {
    const $ = cheerio.load(html);
    const initialSize = html.length;

    // Remove unnecessary tags
    const unnecessaryTags = [
      'script', 'style', 'meta', 'link', 'noscript', 'iframe', 'svg',
      'button', 'input', 'form', 'footer', 'header', 'nav', 'href'
    ];
    unnecessaryTags.forEach(tag => $(tag).remove());

    // Remove comments
    $('*').contents().each((_, element) => {
      if (element.type === 'comment') {
        $(element).remove();
      }
    });

    // Keep only specific attributes
    const keepAttrs = ['datetime', 'title', 'data-img', 'data-thumb'];
    $('*').each((_, element) => {
      if ('attribs' in element) {
        const attributes = element.attribs || {};
        Object.keys(attributes).forEach(attr => {
          if (!keepAttrs.includes(attr)) {
            $(element).removeAttr(attr);
          }
        });
      }
    });

    // Remove empty tags except those with data-img or data-thumb attributes
    $('*').each((_, element) => {
      const $el = $(element);
      if ($el.text().trim() === '' && !$el.attr('style') && !$el.attr('data-img') && $el.children().length === 0) {
        // console.log($el.attr('data-thumb'))
        $el.remove();
      }
    });

    // console.log($.html());
    // Clean whitespace
    let cleanedHtml = $.html()
      .replace(/\n\s*\n/g, '\n')
      .replace(/>\s+</g, '><');

    // Try to get main content
    const mainContent = $('main, [id*="content"], [id*="main"], [class*="content"], [class*="main"]').first();
    if (mainContent.length) {
      cleanedHtml = mainContent.html() || cleanedHtml;
    }

    const finalSize = cleanedHtml.length;
    const reduction = ((initialSize - finalSize) / initialSize) * 100;
    this.logger.log(`HTML cleaning completed. Content reduced by ${reduction.toFixed(2)}%`);

    return cleanedHtml;
  }

  private async processWithOpenAI(htmlContent: string): Promise<Event[]> {
    const startTime = Date.now();
    const TIMEOUT_WARNING = 30000; // 30 seconds
    this.logger.log(`Starting OpenAI processing...`);
    // console.log(htmlContent);
    try {
      const prompt = `
        We are in 2024.
        Extract all event information from the following HTML and return it as a JSON array.
        Each event in the array should follow this format:
        {
          "eventName": string,
          "restaurantName": string,
          "startTime": string (date),
          "endTime": string (date, can be null),
          "price": int (can be null if free, multiply price by 100 for cents),
          "thumbnailUrl": string (represent an image URL),
          "description": string (generate a 100 word description from the eventName and restaurantName),
          "genre": string (infer the genre from the eventName eg: Rock, Jazz, Hip Hop, etc)
        }

        HTML Content:
        ${htmlContent}
      `;


      const response = await this.openai.chat.completions.create({
        model: "gpt-4o-mini",
        messages: [
          {
            role: "system",
            content: "You are an agent that extracts event information from HTML and returns it as a strict JSON array."
          },
          {
            role: "user",
            content: prompt
          }
        ],
        temperature: 0,
      });

      const content = response.choices[0].message.content;
      if (!content) {
        throw new Error('No content in OpenAI response');
      }

      // Clean the response (remove markdown if present)
      const cleaned = content
        .replace(/^```json\s*/, '')
        .replace(/\s*```$/, '')
        .trim();

      const result = JSON.parse(cleaned) as Event[];

      const processingTime = Date.now() - startTime;
      if (processingTime > TIMEOUT_WARNING) {
        this.logger.warn(`OpenAI processing took longer than expected: ${processingTime}ms`);
      } else {
        this.logger.log(`OpenAI processing completed in ${processingTime}ms`);
      }

      return result;
    } catch (error: unknown) {
      const processingTime = Date.now() - startTime;
      const errorMessage = error instanceof Error ? error.message : 'An unknown error occurred';
      this.logger.error(`OpenAI processing error after ${processingTime}ms: ${errorMessage}`);
      throw error;
    }
  }

  async getEvents(url: string): Promise<Event[]> {
    try {
      // Fetch webpage
      const response = await axios.get(url);
      
      // Clean HTML
      const cleanedHtml = this.cleanHtml(response.data);
      
      // Process with OpenAI
      const events = await this.processWithOpenAI(cleanedHtml);
      
      return events;
    } catch (error: unknown) {
      const errorMessage = error instanceof Error ? error.message : 'An unknown error occurred';
      this.logger.error(`Error fetching events from ${url}: ${errorMessage}`);
      throw error;
    }
  }
}
