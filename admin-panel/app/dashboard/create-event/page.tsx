"use client";

import React, { useState } from "react";
import pb from "@/lib/pocketbase";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import {
	Form,
	FormField,
	FormItem,
	FormLabel,
	FormControl,
	FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";

const formSchema = z.object({
	title: z.string().min(1, "Title is required"),
	start: z.string().min(1, "Start time is required"),
	end: z.string().min(1, "End time is required"),
	price: z.string(),
	tickets_available: z.string(),
});

export default function CreateEventPage() {
	const router = useRouter();
	const [error, setError] = useState("");

	const form = useForm({
		resolver: zodResolver(formSchema),
		defaultValues: {
			title: "",
			start: "",
			end: "",
			price: "0",
			tickets_available: "0",
		},
	});

	const onSubmit = async (values: z.infer<typeof formSchema>) => {
		try {
			const user = pb.authStore.model; // Get the logged-in user
			if (!user) throw new Error("User not authenticated.");

			const price = parseFloat(values.price.toString());
			const ticketsAvailable = parseInt(
				values.tickets_available.toString(),
				10
			);

			await pb.collection("live_events").create({
				...values,
				price,
				tickets_available: ticketsAvailable,
				restaurant_id: user.id, // Link event to the logged-in user
			});

			router.push("/dashboard"); // Redirect back to dashboard
		} catch (err: unknown) {
			if (err instanceof Error) {
				setError(err.message);
			} else {
				setError("An error occurred.");
			}
		}
	};

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const preprocessDataBeforeValidation = (data: any) => {
		return {
			...data,
			price: parseFloat(data.price), // Explicitly parse price as number
			tickets_available: parseInt(data.tickets_available, 10), // Explicitly parse tickets_available as number
		};
	};

	const handleLogout = () => {
		pb.authStore.clear(); // Clear session
		router.push("/login"); // Redirect to login
	};

	return (
		<main className="">
			<nav className="text-white py-4">
				<div className="container mx-auto flex justify-between items-center">
					<h1 className="text-3xl font-bold">Create a New Event</h1>
					<div className="flex items-center space-x-4">
						<Button variant="ghost" onClick={handleLogout}>
							Logout
						</Button>
					</div>
				</div>
			</nav>
			<div className="container mx-auto py-10">
				<Form {...form}>
					<form
						onSubmit={form.handleSubmit((data) => {
							// Preprocess data before validating and submitting
							const preprocessedData =
								preprocessDataBeforeValidation(data);
							return onSubmit(preprocessedData);
						})}
						className="space-y-6"
					>
						<FormField
							control={form.control}
							name="title"
							render={({ field }) => (
								<FormItem>
									<FormLabel>Event Title</FormLabel>
									<FormControl>
										<Input
											placeholder="Enter event title"
											{...field}
										/>
									</FormControl>
									<FormMessage />
								</FormItem>
							)}
						/>
						<FormField
							control={form.control}
							name="start"
							render={({ field }) => (
								<FormItem>
									<FormLabel>Start Date & Time</FormLabel>
									<FormControl>
										<Input
											type="datetime-local"
											{...field}
										/>
									</FormControl>
									<FormMessage />
								</FormItem>
							)}
						/>
						<FormField
							control={form.control}
							name="end"
							render={({ field }) => (
								<FormItem>
									<FormLabel>End Date & Time</FormLabel>
									<FormControl>
										<Input
											type="datetime-local"
											{...field}
										/>
									</FormControl>
									<FormMessage />
								</FormItem>
							)}
						/>
						<FormField
							control={form.control}
							name="price"
							render={({ field }) => (
								<FormItem>
									<FormLabel>Price</FormLabel>
									<FormControl>
										<Input
											type="number"
											placeholder="Enter ticket price"
											{...field}
										/>
									</FormControl>
									<FormMessage />
								</FormItem>
							)}
						/>
						<FormField
							control={form.control}
							name="tickets_available"
							render={({ field }) => (
								<FormItem>
									<FormLabel>Tickets Available</FormLabel>
									<FormControl>
										<Input
											type="number"
											placeholder="Enter number of tickets"
											{...field}
										/>
									</FormControl>
									<FormMessage />
								</FormItem>
							)}
						/>
						{error && (
							<p className="text-red-500 text-sm">{error}</p>
						)}
						<Button type="submit" className="w-full">
							Add Event
						</Button>
					</form>
				</Form>
			</div>
		</main>
	);
}
