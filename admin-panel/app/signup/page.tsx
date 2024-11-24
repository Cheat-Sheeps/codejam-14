"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import pb from "@/lib/pocketbase";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

export default function SignUpPage() {
	const [restaurantName, setRestaurantName] = useState("");
	const [email, setEmail] = useState("");
	const [password, setPassword] = useState("");
	const [confirmPassword, setConfirmPassword] = useState("");
	const [city, setCity] = useState("");
	const [thumbnail, setThumbnail] = useState<File | null>(null);
	const [error, setError] = useState("");
	const router = useRouter();

	const handleSignUp = async (e: React.FormEvent<HTMLFormElement>) => {
		e.preventDefault();

		if (password !== confirmPassword) {
			setError("Passwords do not match");
			return;
		}

		if (!thumbnail) {
			setError("Please upload a restaurant thumbnail");
			return;
		}

		try {
			const formData = new FormData();
			formData.append("username", restaurantName.toLowerCase().replace(/\s+/g, "_"));
			formData.append("email", email);
			formData.append("password", password);
			formData.append("passwordConfirm", confirmPassword);
			formData.append("restaurant_name", restaurantName);
			formData.append("city", city);
			formData.append("thumbnail", thumbnail);

			await pb.collection("restaurant_owners").create(formData);

			// After successful signup, log the user in
			await pb.collection("restaurant_owners").authWithPassword(email, password);

			// Redirect to dashboard
			router.push("/dashboard");
		} catch (err: unknown) {
			if (err instanceof Error) {
				setError(err.message || "Failed to create account.");
			} else {
				setError("Failed to create account.");
			}
		}
	};

	const handleThumbnailChange = (e: React.ChangeEvent<HTMLInputElement>) => {
		if (e.target.files && e.target.files[0]) {
			setThumbnail(e.target.files[0]);
		}
	};

	return (
		<div className="max-w-md mx-auto mt-20">
			<h1 className="text-2xl font-bold mb-6">Sign Up</h1>
			<form onSubmit={handleSignUp} className="space-y-4">
				<div>
					<Input
						type="text"
						placeholder="Restaurant Name"
						value={restaurantName}
						onChange={(e: React.ChangeEvent<HTMLInputElement>) => setRestaurantName(e.target.value)}
						required
					/>
				</div>
				<div>
					<Input
						type="email"
						placeholder="Email"
						value={email}
						onChange={(e: React.ChangeEvent<HTMLInputElement>) => setEmail(e.target.value)}
						required
					/>
				</div>
				<div>
					<Input
						type="text"
						placeholder="City"
						value={city}
						onChange={(e: React.ChangeEvent<HTMLInputElement>) => setCity(e.target.value)}
						required
					/>
				</div>
				<div>
					<Input
						type="file"
						accept="image/*"
						onChange={handleThumbnailChange}
						required
					/>
					<p className="text-sm text-gray-500 mt-1">Upload your restaurant thumbnail</p>
				</div>
				<div>
					<Input
						type="password"
						placeholder="Password"
						value={password}
						onChange={(e: React.ChangeEvent<HTMLInputElement>) => setPassword(e.target.value)}
						required
					/>
				</div>
				<div>
					<Input
						type="password"
						placeholder="Confirm Password"
						value={confirmPassword}
						onChange={(e: React.ChangeEvent<HTMLInputElement>) => setConfirmPassword(e.target.value)}
						required
					/>
				</div>
				{error && <p className="text-red-500">{error}</p>}
				<Button type="submit" className="w-full">
					Sign Up
				</Button>
				<div className="text-center mt-4">
					<Button
						type="button"
						variant="outline"
						className="w-full"
						onClick={() => router.push('/login')}
					>
						Back to Login
					</Button>
				</div>
			</form>
		</div>
	);
}
