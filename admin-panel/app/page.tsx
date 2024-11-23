"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import pb from "@/lib/pocketbase";

export default function HomePage() {
	const router = useRouter();

	useEffect(() => {
		// Check if the user is logged in by checking the PocketBase auth store
		const user = pb.authStore.model;

		if (user) {
			// If the user is authenticated, redirect them to the dashboard
			router.push("/dashboard");
		} else {
			// If the user is not authenticated, redirect them to the login page
			router.push("/login");
		}
	}, [router]);

	return (
		<div className="flex items-center justify-center h-screen">
			<h1 className="text-3xl font-bold">Loading...</h1>
		</div>
	);
}
