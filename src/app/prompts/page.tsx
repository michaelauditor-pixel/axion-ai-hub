import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "AI Prompt Library",
  description: "Curated AI prompts for marketing, SEO, content, startups, business analysis and productivity workflows.",
  alternates: { canonical: "/prompts" },
};

const prompts = [
  ["Marketing strategy", "Clarify audience, offer, positioning, channels and measurable next actions."],
  ["SEO planning", "Turn a topic into search intent, keyword clusters and content priorities."],
  ["Content creation", "Move from raw idea to structured, audience-aware content direction."],
  ["Startup analysis", "Evaluate a business idea through problem, market, differentiation and execution risk."],
  ["Sales messaging", "Build concise, benefit-led messaging around a concrete customer problem."],
  ["Productivity", "Convert an objective into a prioritized, repeatable execution plan."],
];

export default function PromptsPage() {
  return <main className="page-shell"><section className="section-heading"><span className="eyebrow">Prompt Library</span><h1>Better context creates better AI output.</h1><p>Use concise, reusable prompt frameworks to make common marketing, SEO, content and business workflows more consistent.</p></section><section className="card-grid">{prompts.map(([name,text])=><article className="feature-card" key={name}><span className="icon-box">⌘</span><h2>{name}</h2><p>{text}</p><a className="text-link" href="/tools">Run with an AI tool →</a></article>)}</section></main>;
}
