import "./globals.css";
export const metadata = {
  title: "AXION AI HUB",
  description: "Global AI tools platform",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <head>
        <script
          async
          src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-3426854646828904"
          crossOrigin="anonymous"
        ></script></head>
      <body style={{ fontFamily: "Arial, sans-serif", padding: "20px" }}>
        {children}
      </body>
    </html>
  );
}


