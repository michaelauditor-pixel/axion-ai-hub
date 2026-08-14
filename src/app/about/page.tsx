import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "About AXION AI HUB",
  description: "AXION AI HUB is a global AI creation platform focused on practical workflows for growth, content, SEO and business execution.",
  alternates: { canonical: "/about" },
};

export default function AboutPage() {
  return (
    <main className="page-shell">
      <section className="section-heading">
        <span className="eyebrow">About AXION</span>
        <h1>Practical AI for real work.</h1>
        <p>AXION AI HUB is built around a simple principle: AI should reduce friction between intent and useful output. The platform combines focused tools, reusable prompts and workflow templates for creators, marketers, founders and teams.</p>
      </section>
      <section className="card-grid">
        <article className="feature-card"><h2>Useful by default</h2><p>Tools are designed around concrete tasks instead of generic chat experiences.</p></article>
        <article className="feature-card"><h2>Built for discovery</h2><p>Clear information architecture helps users and search engines find the right workflow.</p></article>
        <article className="feature-card"><h2>Designed to scale</h2><p>The platform is structured for global categories, multilingual growth and commercial workflows.</p></article>
      </section>
      <section className="cta-band"><div><span className="eyebrow">Explore</span><h2>Find the AI workflow for your next task.</h2></div><a className="button light" href="/tools">Browse tools</a></section>
    </main>
  );
}
