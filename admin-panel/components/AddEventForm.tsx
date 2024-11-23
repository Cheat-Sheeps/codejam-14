"use client";

import React, { useState } from "react";
import pb from "@/lib/pocketbase";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";

export default function AddEventForm() {
	const [title, setTitle] = useState("");
	const [date, setDate] = useState("");
	const [hours, setHours] = useState<number | "">("");
	const [price, setPrice] = useState<number | "">("");
	const [ticketsAvailable, setTicketsAvailable] = useState<number | "">("");
	const [error, setError] = useState("");

	const handleSubmit = async (e: React.FormEvent) => {
		e.preventDefault();
		const user = pb.authStore.model;

		try {
			if (!user) throw new Error("User not authenticated.");

			await pb.collection("live_events").create({
				title,
				date,
				hours: Number(hours),
				price: Number(price),
				tickets_available: Number(ticketsAvailable),
				restaurant_id: user.id,
			});

			alert("Event created successfully!");
			setTitle("");
			setDate("");
			setHours("");
			setPrice("");
			setTicketsAvailable("");
		} catch (err: unknown) {
			if (err instanceof Error) {
				setError(err.message || "An error occurred.");
			} else {
				setError("An error occurred.");
			}
		}
	};

	return (
		<form onSubmit={handleSubmit} className="space-y-4">
			<div>
				<Label htmlFor="title">Event Title</Label>
				<Input
					id="title"
					value={title}
					onChange={(e) => setTitle(e.target.value)}
					placeholder="Enter event title"
				/>
			</div>
			<div>
				<Label htmlFor="date">Date</Label>
				<Input
					id="date"
					type="date"
					value={date}
					onChange={(e) => setDate(e.target.value)}
				/>
			</div>
			<div>
				<Label htmlFor="hours">Hours</Label>
				<Input
					id="hours"
					type="number"
					value={hours}
					onChange={(e) => setHours(e.target.valueAsNumber || "")}
				/>
			</div>
			<div>
				<Label htmlFor="price">Price</Label>
				<Input
					id="price"
					type="number"
					value={price}
					onChange={(e) => setPrice(e.target.valueAsNumber || "")}
				/>
			</div>
			<div>
				<Label htmlFor="tickets">Tickets Available</Label>
				<Input
					id="tickets"
					type="number"
					value={ticketsAvailable}
					onChange={(e) =>
						setTicketsAvailable(e.target.valueAsNumber || "")
					}
				/>
			</div>
			{error && <p className="text-red-500 text-sm">{error}</p>}
			<Button type="submit" className="w-full">
				Add Event
			</Button>
		</form>
	);
}
