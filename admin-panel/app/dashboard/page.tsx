"use client";

import React, { useEffect, useState } from "react";
import pb from "@/lib/pocketbase";
import { Button } from "@/components/ui/button";
import { TableHeader, TableRow, TableHead, TableBody, TableCell, Table } from "@/components/ui/table";
import { useRouter } from "next/navigation";
import { Edit, Trash } from "lucide-react";

interface Event {
	id: string;
	title: string;
	start: string;
	end: string;
	hours: number;
	price: number;
	tickets_available: number;
}

export default function DashboardPage() {
	const [events, setEvents] = useState([] as Event[]);
	const router = useRouter();

	useEffect(() => {
		const fetchEvents = async () => {
			const user = pb.authStore.model;
			if (!user) return;

			const result = await pb.collection("live_events").getFullList({
				filter: `restaurant_id = "${user.id}"`,
				sort: "-start",
			}) as Event[];

			setEvents(result);
		};

		fetchEvents();
	}, []);

	const handleEdit = (eventId: string) => {
		router.push(`/dashboard/edit-event/${eventId}`);
	};

	const handleDelete = async (eventId: string) => {
		try {
			await pb.collection("live_events").delete(eventId);
			setEvents(events.filter((event) => event.id !== eventId));
		} catch (error) {
			console.error("Error deleting event:", error);
		}
	};

	const handleLogout = () => {
		pb.authStore.clear();
		router.push("/login");
	};

	const formatPrice = (price: number) => {
		return new Intl.NumberFormat("en-US", {
			style: "currency",
			currency: "USD",
		}).format(price / 100);
	}

	return (
		<div className="">
			<nav className="py-4">
				<div className="container mx-auto flex justify-between items-center">
					<div className="flex flex-col gap-1">
						<h1 className="text-3xl font-bold">Your Events</h1>
						<p className="text-sm text-gray-500">
							{pb.authStore.model?.email}
						</p>
					</div>
					<div className="flex items-center space-x-4">
						<Button
							onClick={() => router.push("/dashboard/create-event")}
						>
							Create Event
						</Button>
						<Button
							onClick={() => router.push("/dashboard/import-events")}
							variant="secondary"
						>
							Import Events
						</Button>
						<Button variant="ghost" onClick={handleLogout}>
							Logout
						</Button>
					</div>
				</div>
			</nav>
			<div className="container mx-auto py-10">
				<div className="overflow-x-auto">
					<Table>
						<TableHeader>
							<TableRow>
								<TableHead>Title</TableHead>
								<TableHead>Start</TableHead>
								<TableHead>End</TableHead>
								<TableHead>Price</TableHead>
								<TableHead>Tickets Available</TableHead>
								<TableHead></TableHead>
							</TableRow>
						</TableHeader>
						<TableBody>
							{events.map((event) => (
								<TableRow key={event.id}>
									<TableCell>{event.title}</TableCell>
									<TableCell>
										{new Date(event.start).toLocaleString()}
									</TableCell>
									<TableCell>
										{new Date(event.end).toLocaleString()}
									</TableCell>
									<TableCell>
										{formatPrice(event.price)}
									</TableCell>
									<TableCell>
										{event.tickets_available}
									</TableCell>
									<TableCell className="flex justify-end">
										<Button
											variant="outline"
											onClick={() => handleEdit(event.id)}
										>
											<Edit />
										</Button>
										<Button
											variant="destructive"
											onClick={() => handleDelete(event.id)}
											className="ml-2"
										>
											<Trash />
										</Button>
									</TableCell>
								</TableRow>
							))}
						</TableBody>
					</Table>
				</div>
			</div>
		</div>
	);
}
