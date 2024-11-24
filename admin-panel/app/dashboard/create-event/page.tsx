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
import { Textarea } from "@/components/ui/textarea";

const formSchema = z.object({
	title: z.string().min(1, "Title is required"),
	start: z.string().min(1, "Start time is required"),
	genre: z.string().min(1, "Genre is required"),
	thumbnail: z.any(),
	description: z.string().min(1, "Description is required"),
	price: z.string(),
	tickets_available: z.string(),
});

export default function CreateEventPage() {
	const router = useRouter();
	const [error, setError] = useState("");
	const [thumbnail, setThumbnail] = useState<File | null>(null);

	const form = useForm({
		resolver: zodResolver(formSchema),
		defaultValues: {
			title: "",
			start: "",
			genre: "",
			thumbnail: undefined,
			description: "",
			price: "0",
			tickets_available: "100",
		},
	});

	const onSubmit = async (values: z.infer<typeof formSchema>) => {
		try {
			const user = pb.authStore.model; // Get the logged-in user
			console.log(pb.authStore);
			if (!user) throw new Error("User not authenticated.");

			const price = parseFloat(values.price.toString()) * 100;
			const ticketsAvailable = parseInt(
				values.tickets_available.toString(),
				10
			);

			const formData = new FormData();

			formData.append("title", values.title);
			formData.append("start", new Date(values.start).toISOString());
			formData.append("genre", values.genre);
			formData.append("description", values.description);
			if (thumbnail)
				formData.append("thumbnail", thumbnail);
			formData.append("price", price.toString());
			formData.append("tickets_available", ticketsAvailable.toString());
			formData.append("restaurant_id", user.id);

			await pb.collection("live_events").create(formData);

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


	const handleThumbnailChange = (e: React.ChangeEvent<HTMLInputElement>) => {
		if (e.target.files && e.target.files[0]) {
			setThumbnail(e.target.files[0]);
		}
	};

	return (
		<main className="">
			<nav className="py-4">
				<div className="container mx-auto flex justify-between items-center">
					<h1 className="text-3xl font-bold">Create a New Event</h1>
					<div className="flex items-center space-x-4">
						<Button variant="ghost" onClick={handleLogout}>
							Logout
						</Button>
					</div>
				</div>
			</nav>
			<div className="py-10 max-w-2xl mx-auto mt-20 gap-6">
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
						<div className=" grid grid-cols-2 gap-6">
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
								name="genre"
								render={({ field }) => (
									<FormItem>
										<FormLabel>Music Genre</FormLabel>
										<FormControl>
											<Input
												placeholder="Enter event music genre"
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
								name="price"
								render={({ field }) => (
									<FormItem>
										<FormLabel>Price</FormLabel>
										<FormControl>
											<Input
												type="number"
												step={0.01}
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
							<FormField
								control={form.control}
								name="thumbnail"
								render={({ field }) => (
									<FormItem>
										<FormLabel>Event Thumbnail</FormLabel>
										<FormControl>
											<Input
												{...field}
												type="file"
												accept="image/*"
												onChange={handleThumbnailChange}
												required
											/>
										</FormControl>
										<FormMessage />
									</FormItem>
								)}
							/>
							<div className="col-span-2">
								<FormField
									control={form.control}
									name="description"
									render={({ field }) => (
										<FormItem>
											<FormLabel>Description</FormLabel>
											<FormControl>
												<Textarea
													placeholder="Enter event description"
													{...field}
												/>
											</FormControl>
											<FormMessage />
										</FormItem>
									)}
								/>
							</div>
						</div>
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
