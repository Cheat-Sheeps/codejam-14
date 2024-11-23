"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import pb from "@/lib/pocketbase";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

export default function LoginPage() {
	const [email, setEmail] = useState("");
	const [password, setPassword] = useState("");
	const [error, setError] = useState("");
	const router = useRouter();

	const handleLogin = async (e: React.FormEvent) => {
		e.preventDefault();

		try {
			// Check if a user is already authenticated
			if (pb.authStore.isValid) {
				router.push("/dashboard"); // If user is already logged in, redirect to dashboard
				return;
			}

			// Try to authenticate the user
			await pb
				.collection("restaurant_owners")
				.authWithPassword(email, password);

			// Redirect to dashboard on successful login
			router.push("/dashboard");
		} catch (err: unknown) {
			if (err instanceof Error) {
				setError(err.message || "Invalid credentials.");
			} else {
				setError("Invalid credentials.");
			}
		}
	};

	return (
		<div className="max-w-md mx-auto mt-20">
			<h1 className="text-2xl font-bold mb-6">Login</h1>
			<form onSubmit={handleLogin} className="space-y-4">
				<div>
					<Input
						type="email"
						placeholder="Email"
						value={email}
						onChange={(e) => setEmail(e.target.value)}
					/>
				</div>
				<div>
					<Input
						type="password"
						placeholder="Password"
						value={password}
						onChange={(e) => setPassword(e.target.value)}
					/>
				</div>
				{error && <p className="text-red-500">{error}</p>}
				<Button type="submit" className="w-full">
					Login
				</Button>
			</form>
		</div>
	);
}
