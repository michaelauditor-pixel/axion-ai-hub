import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Contact & Enterprise",
  description: "Contact AXION AI HUB about enterprise AI workflows, commercial use and platform partnerships.",
  alternates: { canonical: "/contact" },
};

export default function ContactPage() {
  return (
    <main className="page-shell">
      <section className="section-heading centered"><span className="eyebrow">Enterprise</span><h1>Build AI workflows around your team.</h1><p>For higher-volume usage, commercial workflows, partnerships or enterprise requirements, contact the AXION team.</p></section>
      <section className="pricing-grid">
        <article className="pricing-card"><h2>Teams</h2><p className="muted">Standardize repeatable AI-assisted work across marketing, content and operations.</p><a className="button secondary" href="mailto:contact@axionaihub.com?subject=AXION%20AI%20HUB%20Team%20Inquiry">Contact team</a></article>
        <article className="pricing-card featured"><span className="badge">Enterprise</span><h2>Custom workflows</h2><p className="muted">Discuss higher usage, integrations and purpose-built workflows for your organization.</p><a className="button primary" href="mailto:contact@axionaihub.com?subject=AXION%20AI%20HUB%20Enterprise">Talk to enterprise</a></article>
        <article className="pricing-card"><h2>Partnerships</h2><p className="muted">Explore distribution, affiliate, technology and content partnerships.</p><a className="button secondary" href="mailto:contact@axionaihub.com?subject=AXION%20AI%20HUB%20Partnership">Discuss partnership</a></article>
      </section>
    </main>
  );
}
