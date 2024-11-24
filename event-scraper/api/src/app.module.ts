import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { EventsController } from "./controllers/events.controller";
import { ScraperService } from "./services/scraper.service";
import { PocketBaseService } from "./services/pocketbase.service";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
  ],
  controllers: [EventsController],
  providers: [ScraperService, PocketBaseService],
})
export class AppModule {}
