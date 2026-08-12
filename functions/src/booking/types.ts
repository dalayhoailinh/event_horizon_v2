import { z } from "zod";

export const createBookingSchema = z.object({
  eventId: z.string().min(1),
  bookingIntentId: z.string().regex(/^[a-z0-9_-]{10,64}$/),
  items: z
    .array(
      z.object({
        ticketTypeId: z.string().min(1),
        quantity: z.number().int().min(1).max(10),
      }),
    )
    .min(1)
    .max(5),
});

export type CreateBookingInput = z.infer<typeof createBookingSchema>;

export const cancelBookingSchema = z.object({
  bookingId: z.string().min(1),
});
