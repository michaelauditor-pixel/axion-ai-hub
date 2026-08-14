import type { Metadata, Viewport } from "next";
import Link from "next/link";
import Script from "next/script";
import "./globals.css";

const SITE_URL = "https://axionaihub.com";
const googleVerification = process.env.GOOGLE_SITE_VERIFICATION || "c7hr4Fgjb001_abvYyuvzJaBzUlfIitgxW6zZLYhZ1s";
const gtmId = process.env.NEXT_PUBLIC_GTM_ID || process.env.GTM_ID || "GTM-5ZSZWVJX";
const gaId = process.env.NEXT_PUBLIC_GA4_MEASUREMENT_ID || process.env.GA4_MEASUREMENT_ID || "G-YT7WZM6DPX";

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  themeColor: "#070b16",
  colorScheme: "dark",
};

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    default: "AXION AI HUB — AI Tools for Marketing, SEO, Content and Business",
    template: "%s | AXION AI HUB",
  },
  description: "A global AI workspace with practical tools, prompts, templates and workflows for marketing, SEO, content, sales, productivity and business execution.",
  applicationName: "AXION AI HUB",
  category: "technology",
  keywords: ["AI tools", "AI marketing tools", "AI SEO tools", "AI content tools", "business AI", "AI productivity", "AI automation"],
  alternates: { canonical: "/", languages: { "en": "/", "x-default": "/" } },
  verification: { google: googleVerification },
  robots: {
    index: true,
    follow: true,
    nocache: false,
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
    title: "AXION AI HUB — Practical AI Tools for Growth and Execution",
    description: "Use focused AI tools and repeatable workflows for marketing, SEO, content, sales and business operations.",
    locale: "en_US",
  },
  twitter: {
    card: "summary_large_image",
    title: "AXION AI HUB — Practical AI Tools for Growth and Execution",
    description: "Focused AI tools and workflows for marketing, SEO, content, sales and business execution.",
  },
  manifest: "/manifest.webmanifest",
};

const jsonLd = {
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": `${SITE_URL}/#organization`,
      name: "AXION AI HUB",
      url: SITE_URL,
      description: "Global AI creation and workflow platform for practical business execution.",
    },
    {
      "@type": "WebSite",
      "@id": `${SITE_URL}/#website`,
      url: SITE_URL,
      name: "AXION AI HUB",
      publisher: { "@id": `${SITE_URL}/#organization` },
      inLanguage: "en",
    },
    {
      "@type": "SoftwareApplication",
      "@id": `${SITE_URL}/#software`,
      name: "AXION AI HUB",
      applicationCategory: "BusinessApplication",
      operatingSystem: "Web",
      url: SITE_URL,
      offers: [
        { "@type": "Offer", price: "0", priceCurrency: "USD", name: "Free" },
        { "@type": "Offer", price: "9.90", priceCurrency: "USD", name: "Pro" },
      ],
    },
  ],
};

const nav = [
  ["Tools", "/tools"],
  ["Use cases", "/use-cases"],
  ["Templates", "/templates"],
  ["Prompts", "/prompts"],
  ["Pricing", "/pricing"],
  ["Enterprise", "/contact"],
] as const;

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <head>
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />
        <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-3426854646828904" crossOrigin="anonymous" />
        <script async src={`https://www.googletagmanager.com/gtag/js?id=${gaId}`} />
        <script dangerouslySetInnerHTML={{ __html: `window.dataLayer=window.dataLayer||[];function gtag(){dataLayer.push(arguments)}gtag('js',new Date());gtag('config','${gaId}',{anonymize_ip:true});` }} />
      </head>
      <body>
        <Script id="gtm" strategy="afterInteractive" dangerouslySetInnerHTML={{ __html: `(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','${gtmId}');` }} />
        <noscript><iframe src={`https://www.googletagmanager.com/ns.html?id=${gtmId}`} height="0" width="0" style={{ display: "none", visibility: "hidden" }} /></noscript>
        <a className="skip-link" href="#main-content">Skip to content</a>
        <header className="site-header">
          <div className="nav-shell">
            <Link className="brand" href="/" aria-label="AXION AI HUB home"><span className="brand-mark">A</span><span>AXION AI HUB<small>Global AI Creation Platform</small></span></Link>
            <nav className="nav-links" aria-label="Primary navigation">{nav.map(([label, href]) => <Link key={href} href={href}>{label}</Link>)}</nav>
            <Link className="button primary compact" href="/tools">Explore AI tools</Link>
          </div>
        </header>
        <div id="main-content">{children}</div>
        <footer className="site-footer">
          <div className="footer-grid">
            <div><Link className="brand" href="/"><span className="brand-mark">A</span><span>AXION AI HUB<small>Build faster with practical AI.</small></span></Link><p className="footer-note">Practical AI workflows for modern teams, creators and businesses worldwide.</p></div>
            <div><strong>Platform</strong><Link href="/tools">AI Tools</Link><Link href="/use-cases">Use cases</Link><Link href="/templates">Templates</Link><Link href="/prompts">Prompts</Link><Link href="/pricing">Pricing</Link></div>
            <div><strong>Company</strong><Link href="/about">About</Link><Link href="/contact">Contact</Link><Link href="/privacy-policy">Privacy</Link><Link href="/terms-of-service">Terms</Link></div>
          </div>
          <div className="footer-bottom">© {new Date().getFullYear()} AXION AI HUB. AI-powered workflows for global teams.</div>
        </footer>
      </body>
    </html>
  );
}
