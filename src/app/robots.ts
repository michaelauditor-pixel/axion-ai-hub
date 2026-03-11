export default function robots() {
  return {
    rules: {
      userAgent: "*",
      allow: "/",
    },
    sitemap: "https://axion-ai-hub.vercel.app/sitemap.xml",
  };
}
