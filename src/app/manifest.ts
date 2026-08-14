import type { MetadataRoute } from "next";

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "AXION AI HUB",
    short_name: "AXION",
    description: "Practical AI tools and workflows for marketing, SEO, content, sales and business execution.",
    start_url: "/",
    display: "standalone",
    background_color: "#060914",
    theme_color: "#070b16",
    categories: ["business", "productivity", "utilities"],
    icons: [{ src: "/favicon.ico", sizes: "any", type: "image/x-icon" }],
  };
}
