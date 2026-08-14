import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Pricing | AXION AI HUB",
  description: "Choose an AXION AI HUB plan for AI-powered marketing, content, SEO and productivity workflows.",
  alternates: { canonical: "/pricing" },
};

const plans = [
  { name: "Free", price: "$0", note: "Explore the platform", features: ["Daily AI tool usage", "Core generators", "Public templates", "Community resources"], cta: "Explore tools", href: "/tools" },
  { name: "Pro", price: "$9.90", note: "per month", featured: true, features: ["Higher generation limits", "Premium workflows", "Commercial usage", "Priority product access", "Advanced SEO and marketing tools"], cta: "Upgrade to Pro", href: "/tools" },
  { name: "Enterprise", price: "Custom", note: "for teams", features: ["Team workflows", "Governance-ready deployment", "Volume usage", "Priority support", "Custom integrations"], cta: "Contact sales", href: "/contact" },
];

export default function PricingPage() {
  return (
    <main className="page-shell">
      <section className="section-heading centered">
        <span className="eyebrow">Simple pricing</span>
        <h1>Start free. Scale when the workflow proves its value.</h1>
        <p>Access practical AI tools today and upgrade when you need more capacity, advanced workflows and team-scale operations.</p>
      </section>
      <section className="pricing-grid" aria-label="Pricing plans">
        {plans.map((plan) => (
          <article className={`pricing-card${plan.featured ? " featured" : ""}`} key={plan.name}>
            {plan.featured && <span className="badge">Most popular</span>}
            <h2>{plan.name}</h2>
            <div className="price">{plan.price}</div>
            <p className="muted">{plan.note}</p>
            <ul className="feature-list">{plan.features.map((f) => <li key={f}>{f}</li>)}</ul>
            <a className={plan.featured ? "button primary" : "button secondary"} href={plan.href}>{plan.cta}</a>
          </article>
        ))}
      </section>
      <section className="trust-strip">
        <span>Secure checkout</span><span>Clear usage limits</span><span>Cancel anytime</span><span>Built for global workflows</span>
      </section>
    </main>
  );
}
