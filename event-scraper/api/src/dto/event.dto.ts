import { IsString, IsOptional, IsNumber } from 'class-validator';

export class EventDto {
  @IsString()
  eventName: string;

  @IsString()
  restaurantName: string;

  @IsString()
  startTime: string;

  @IsString()
  @IsOptional()
  endTime?: string;

  @IsNumber()
  @IsOptional()
  price?: number;

  @IsString()
  @IsOptional()
  thumbnailUrl?: string;

  @IsString()
  @IsOptional()
  description?: string;
}
