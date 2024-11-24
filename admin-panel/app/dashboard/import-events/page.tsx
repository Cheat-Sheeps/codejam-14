"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import pb from "@/lib/pocketbase";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

export default function ImportEventsPage() {
	const [calendarUrl, setCalendarUrl] = useState("");
	const [error, setError] = useState("");
	const [loading, setLoading] = useState(false);
	const router = useRouter();

	const handleImport = async (e: React.FormEvent<HTMLFormElement>) => {
		e.preventDefault();
		setLoading(true);
		setError("");

		try {
			const user = pb.authStore.model;
			if (!user) {
				router.push("/login");
				return;
			}

			const response = await fetch(`${process.env.NEXT_PUBLIC_EVENT_SCRAPER_URL}/api/v1/get_events?${
                new URLSearchParams({
                    url: calendarUrl,
                    restaurant_id: user.id,
                }).toString()}`, {
				method: "GET",
				headers: {
					"Content-Type": "application/json",
				},
                
                // param: {
                //     restaurant_id: user.id,
                //     url: calendarUrl,
				// },
			});

			if (!response.ok) {
				const data = await response.json();
				throw new Error(data.message || "Failed to import events");
			}

			// Redirect back to dashboard after successful import
			router.push("/dashboard");
		} catch (err) {
			if (err instanceof Error) {
				setError(err.message);
			} else {
				setError("Failed to import events");
			}
		} finally {
			setLoading(false);
		}
	};

	return (
		<div className="container mx-auto max-w-2xl py-10">
			<div className="flex justify-between items-center mb-8">
				<h1 className="text-3xl font-bold">Import Events</h1>
				<Button
					variant="outline"
					onClick={() => router.push("/dashboard")}
				>
					Back to Dashboard
				</Button>
			</div>

			<form onSubmit={handleImport} className="space-y-6">
				<div className="space-y-2">
					<Input
						type="url"
						placeholder="Calendar URL"
						value={calendarUrl}
						onChange={(e) => setCalendarUrl(e.target.value)}
						required
					/>
					<p className="text-sm text-gray-500">
						Enter the URL of your calendar to import events
					</p>
				</div>

				{error && (
					<p className="text-red-500">{error}</p>
				)}

				<Button
					type="submit"
					className="w-full"
					disabled={loading}
				>
					{loading ? "Importing..." : "Import Events"}
				</Button>
			</form>
		</div>
	);
}
