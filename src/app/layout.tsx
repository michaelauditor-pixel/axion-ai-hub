import type { Metadata } from "next";
import Link from "next/link";
import Script from "next/script";
import "./globals.css";

const SITE_URL = "https://axionaihub.com";
const googleVerification = process.env.GOOGLE_SITE_VERIFICATION;
const gtmId = process.env.NEXT_PUBLIC_GTM_ID || process.env.GTM_ID;
const gaId = process.env.NEXT_PUBLIC_GA4_MEASUREMENT_ID || process.env.GA4_MEASUREMENT_ID;

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: { default: "AXION AI HUB — AI Tools for Growth, Content and Automation", template: "%s | AXION AI HUB" },
  description: "Discover practical AI tools for marketing, SEO, content, business, productivity and automation. Built for creators, founders and teams.",
  applicationName: "AXION AI HUB",
  category: "technology",
  alternates: { canonical: "/" },
  verification: googleVerification ? { google: googleVerification } : undefined,
  robots: { index: true, follow: true, googleBot: { index: true, follow: true, "max-image-preview": "large", "max-snippet": -1, "max-video-preview": -1 } },
  openGraph: { type: "website", url: SITE_URL, siteName: "AXION AI HUB", title: "AXION AI HUB — AI Tools for Growth, Content and Automation", description: "Practical AI tools and workflows for marketing, SEO, content, business and productivity." },
  twitter: { card: "summary_large_image", title: "AXION AI HUB — AI Tools for Growth, Content and Automation", description: "Practical AI tools and workflows for marketing, SEO, content, business and productivity." },
};

const jsonLd = { "@context": "https://schema.org", "@graph": [
  { "@type": "Organization", "@id": `${SITE_URL}/#organization`, name: "AXION AI HUB", url: SITE_URL },
  { "@type": "WebSite", "@id": `${SITE_URL}/#website`, url: SITE_URL, name: "AXION AI HUB", publisher: { "@id": `${SITE_URL}/#organization` }, inLanguage: "en" },
] };

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return <html lang="en"><head>
    <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />
    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-3426854646828904" crossOrigin="anonymous" />
    {gaId && <><script async src={`https://www.googletagmanager.com/gtag/js?id=${gaId}`} /><script dangerouslySetInnerHTML={{__html:`window.dataLayer=window.dataLayer||[];function gtag(){dataLayer.push(arguments)}gtag('js',new Date());gtag('config','${gaId}',{anonymize_ip:true});`}} /></>}
  </head><body>
    {gtmId && <><Script id="gtm" strategy="afterInteractive" dangerouslySetInnerHTML={{__html:`(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','${gtmId}');`}} /><noscript><iframe src={`https://www.googletagmanager.com/ns.html?id=${gtmId}`} height="0" width="0" style={{display:"none",visibility:"hidden"}} /></noscript></>}
    <a className="skip-link" href="#main-content">Skip to content</a>
    <header className="site-header"><div className="nav-shell"><Link className="brand" href="/"><span className="brand-mark">A</span><span>AXION AI HUB<small>Global AI Creation Platform</small></span></Link><nav className="nav-links"><a href="/tools">Tools</a><a href="/use-cases">Use cases</a><a href="/templates">Templates</a><a href="/prompts">Prompts</a><a href="/pricing">Pricing</a><a href="/contact">Enterprise</a></nav><a className="button primary compact" href="/tools">Explore AI tools</a></div></header>
    <div id="main-content">{children}</div>
    <footer className="site-footer"><div className="footer-grid"><div><Link className="brand" href="/"><span className="brand-mark">A</span><span>AXION AI HUB<small>Build faster with practical AI.</small></span></Link></div><div><strong>Platform</strong><a href="/tools">AI Tools</a><a href="/use-cases">Use cases</a><a href="/templates">Templates</a><a href="/prompts">Prompts</a><a href="/pricing">Pricing</a></div><div><strong>Company</strong><a href="/about">About</a><a href="/contact">Contact</a><a href="/privacy-policy">Privacy</a><a href="/terms-of-service">Terms</a></div></div><div className="footer-bottom">© {new Date().getFullYear()} AXION AI HUB. AI-powered workflows for global teams.</div></footer>
  </body></html>;
}
