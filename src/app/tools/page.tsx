import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Free AI Tools Directory",
  description: "Explore practical AI tools for marketing, SEO, business, content creation, productivity and growth.",
  alternates: { canonical: "/tools" },
};

const tools = [
  ["AI Business Tools", "Marketing", "Turn a business objective into structured, actionable output."],
  ["SEO Keyword Generator", "SEO", "Generate keyword directions and content opportunities for organic discovery."],
  ["YouTube Title Generator", "Content", "Create stronger video-title concepts for clarity, curiosity and search intent."],
  ["AI Marketing Copy", "Marketing", "Create campaign angles, offers and conversion-oriented messaging."],
  ["Startup Name Generator", "Business", "Explore brandable startup and product naming directions."],
  ["Prompt Builder", "Productivity", "Structure clearer prompts for repeatable AI-assisted workflows."],
];

const categories = ["All tools", "Marketing", "SEO", "Content", "Business", "Productivity"];

export default function ToolsPage() {
  return (
    <main className="page-shell">
      <section className="directory-hero">
        <span className="eyebrow">AI Tools Directory</span>
        <h1>Practical AI tools for the work that drives growth.</h1>
        <p>Explore focused generators and workflows for marketing, SEO, content, business and productivity. Start free and move from input to usable output in seconds.</p>
        <div className="search-shell" role="search"><span>⌕</span><input aria-label="Search AI tools" placeholder="Search tools by task or category" /></div>
        <div className="chip-row">{categories.map((c) => <a href="#tool-grid" key={c}>{c}</a>)}</div>
      </section>

      <section className="section-block" id="tool-grid">
        <div className="section-heading row"><div><span className="eyebrow">Featured workflows</span><h2>Start with a real task.</h2></div><a className="text-link" href="/pricing">Compare plans →</a></div>
        <div className="tool-grid">{tools.map(([name, category, description], index) => <article className="tool-card" key={name}><div className="tool-card-top"><span className="tool-icon">{index + 1}</span><span className="badge subtle">{category}</span></div><h3>{name}</h3><p>{description}</p><a className="button secondary full" href="/tools">Open tool</a></article>)}</div>
      </section>

      <section className="split-section compact-split"><div><span className="eyebrow">Built for discovery</span><h2>Find the right AI workflow faster.</h2><p>AXION organizes tools around user intent and practical outcomes, helping search engines and users understand each workflow clearly.</p></div><div className="mini-grid"><a href="/prompts"><strong>Prompt Library</strong><span>Reusable frameworks →</span></a><a href="/templates"><strong>Templates</strong><span>Ready-made structures →</span></a><a href="/pricing"><strong>AXION Pro</strong><span>Higher usage limits →</span></a><a href="/contact"><strong>Enterprise</strong><span>Team workflows →</span></a></div></section>
    </main>
  );
}
