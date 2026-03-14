import "./globals.css";
import Script from "next/script"

export const metadata = {
  title: "AXION AI HUB",
  description: "Global AI tools platform",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <head>
        <Script
          id="adsense-script"
          strategy="beforeInteractive"
          async
          src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-3426854646828904"
          crossOrigin="anonymous"
        />
        
      </head>
      <body style={{ fontFamily: "Arial, sans-serif", padding: "20px" }}>
        {children}
      </body>
    </html>
  );
}

