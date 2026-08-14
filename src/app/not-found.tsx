import type { Metadata } from "next";

export const metadata: Metadata = { title: "Page not found", robots: { index: false, follow: true } };

export default function NotFound() {
  return (
    <main className="page-shell">
      <section className="section-heading centered"><span className="eyebrow">404</span><h1>This page is not available.</h1><p>The URL may have changed or the page may no longer exist. Continue through the main tool directory instead of hitting a dead end.</p><div className="hero-actions" style={{justifyContent:"center"}}><a className="button primary" href="/tools">Browse AI tools</a><a className="button secondary" href="/">Back home</a></div></section>
    </main>
  );
}
