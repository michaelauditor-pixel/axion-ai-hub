import type { MetadataRoute } from "next";

const SITE_URL = "https://axionaihub.com";

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: "*",
        allow: "/",
        disallow: ["/api/", "/dashboard/", "/command-center/", "/control/"],
      },
    ],
    sitemap: [
      `${SITE_URL}/sitemap.xml`,
      `${SITE_URL}/sitemap-full.xml`,
      `${SITE_URL}/sitemap-hypergrowth.xml`,
    ],
    host: SITE_URL,
  };
}
