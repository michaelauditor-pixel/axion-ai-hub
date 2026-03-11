import Script from 'next/script';

export const metadata = {
  title: 'AXION AI HUB',
  description: 'Global AI tools platform'
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <head>
        <Script
          async
          src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-3426854646828904"
          crossOrigin="anonymous"
          strategy="afterInteractive"
        />
      </head>
      <body style={{fontFamily:"Arial",padding:"20px"}}>
        {children}
      </body>
    </html>
  );
}
