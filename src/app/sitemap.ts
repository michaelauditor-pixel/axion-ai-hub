import type { MetadataRoute } from "next";

const SITE_URL = "https://axionaihub.com";

export default function sitemap(): MetadataRoute.Sitemap {
  const now = new Date();
  const routes = [
    "",
    "/about",
    "/contact",
    "/privacy-policy",
    "/terms-of-service",
    "/tools",
    "/templates",
    "/prompts",
  ];

  return routes.map((route) => ({
    url: `${SITE_URL}${route}`,
    lastModified: now,
    changeFrequency: route === "" ? "daily" : "weekly",
    priority: route === "" ? 1 : route === "/tools" ? 0.9 : 0.7,
  }));
}
