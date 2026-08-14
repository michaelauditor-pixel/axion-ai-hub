import type { Metadata } from "next";
import "./globals.css";

const SITE_URL = "https://axionaihub.com";

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    default: "AXION AI HUB — Global AI Creation Platform",
    template: "%s | AXION AI HUB",
  },
  description:
    "AI-powered tools for creation, SEO, marketing, productivity and automation across global workflows.",
  alternates: {
    canonical: "/",
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-image-preview": "large",
      "max-snippet": -1,
      "max-video-preview": -1,
    },
  },
  openGraph: {
    type: "website",
    url: SITE_URL,
    siteName: "AXION AI HUB",
    title: "AXION AI HUB — Global AI Creation Platform",
    description:
      "AI-powered tools for creation, SEO, marketing, productivity and automation.",
  },
  twitter: {
    card: "summary_large_image",
    title: "AXION AI HUB — Global AI Creation Platform",
    description:
      "AI-powered tools for creation, SEO, marketing, productivity and automation.",
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <head>
        <script
          async
          src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-3426854646828904"
          crossOrigin="anonymous"
        />
      </head>
      <body style={{ fontFamily: "Arial, sans-serif", padding: "20px" }}>{children}</body>
    </html>
  );
}
