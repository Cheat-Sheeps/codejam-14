import PocketBase from "pocketbase";

const pb = new PocketBase(process.env.NEXT_PUBLIC_POCKETBASE_URL);

// PocketBase initialization
if (typeof window !== "undefined") {
  pb.authStore.loadFromCookie(document.cookie); // Restore session from cookie
  
  pb.authStore.onChange(() => {
    // Save session to cookie
    document.cookie = pb.authStore.exportToCookie({ httpOnly: false });
  });
}


export default pb;
