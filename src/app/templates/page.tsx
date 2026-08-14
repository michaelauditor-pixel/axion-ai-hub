import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "AI Workflow Templates",
  description: "Reusable AI workflow templates for marketing, SEO, content creation, business and productivity.",
  alternates: { canonical: "/templates" },
};

const items = [
  ["Marketing campaign brief", "Structure audience, offer, channels and campaign direction."],
  ["SEO content brief", "Turn search intent into a clear, production-ready content structure."],
  ["Landing page framework", "Organize positioning, proof, benefits and conversion actions."],
  ["Business analysis", "Frame a problem, evidence, options and recommended next actions."],
  ["Content repurposing", "Transform one core asset into channel-specific derivatives."],
  ["AI workflow SOP", "Document repeatable AI-assisted operating steps for a team."],
];

export default function TemplatesPage() {
  return <main className="page-shell"><section className="section-heading"><span className="eyebrow">Templates</span><h1>Reusable structures for repeatable AI work.</h1><p>Reduce setup time with practical templates that make outputs more consistent across common growth and business workflows.</p></section><section className="card-grid">{items.map(([name,text])=><article className="feature-card" key={name}><span className="icon-box">▦</span><h2>{name}</h2><p>{text}</p><a className="text-link" href="/tools">Use with AI tools →</a></article>)}</section></main>;
}
