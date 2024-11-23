export interface Event {
  eventName: string;
  restaurantName: string;
  startTime: string;
  endTime?: string;
  price?: number;
  thumbnailUrl?: string;
  description?: string;
  genre?: string;
}
