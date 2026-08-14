import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "AI Tools for Marketing, SEO, Content and Business",
  description: "Use AXION AI HUB to generate, optimize and scale marketing, SEO, content, sales and business workflows with practical AI tools built for real execution.",
  alternates: { canonical: "/" },
};

const categories = [
  ["AI Marketing", "Campaign ideas, copy, positioning, offers and conversion workflows.", "/use-cases/agencies"],
  ["SEO & Growth", "Keyword, content and organic-growth workflows built for discoverability.", "/use-cases/seo-teams"],
  ["Content Creation", "Faster ideation and production for web, social, email and video.", "/use-cases/content-marketing"],
  ["Sales", "Prospecting, follow-up, value propositions and customer communication.", "/use-cases/sales-teams"],
  ["Business", "Practical strategy, research, positioning and operational output for teams.", "/use-cases/small-business"],
  ["Templates & Prompts", "Reusable frameworks that reduce repetitive knowledge work.", "/templates"],
] as const;

const outcomes = ["Production-ready workflows", "SEO-first architecture", "Global use cases", "Free tools available"];
const capabilities = [
  ["01", "Discover", "Find the right workflow for your objective, audience and channel."],
  ["02", "Generate", "Turn context into a useful first result with focused AI tools."],
  ["03", "Refine", "Improve tone, structure, positioning and commercial relevance."],
  ["04", "Scale", "Repeat proven workflows across teams, campaigns and channels."],
] as const;
const audiences = ["Marketing teams", "SEO specialists", "Founders", "Agencies", "Creators", "Sales teams", "Ecommerce", "Local businesses"];

export default function Home() {
  return (
    <main className="page-shell home-page">
      <section className="hero">
        <div className="hero-copy">
          <span className="eyebrow">Enterprise-grade AI workflow platform</span>
          <h1>Turn business intent into usable AI output.</h1>
          <p className="hero-lead">AXION AI HUB brings focused AI tools, reusable prompts, templates and growth workflows into one execution layer for modern teams, creators and businesses.</p>
          <div className="hero-actions"><Link className="button primary" href="/tools">Explore AI tools</Link><Link className="button secondary" href="/use-cases">Explore use cases</Link></div>
          <div className="hero-proof"><span>No setup required</span><span>Built for practical output</span><span>Free tier available</span><span>Commercial workflows</span></div>
        </div>
        <div className="hero-panel enterprise-panel">
          <div className="panel-top"><span className="status-dot" /> AXION AI workspace <span className="panel-live">Operational</span></div>
          <div className="metric-grid"><div><strong>AI</strong><small>Generation</small></div><div><strong>SEO</strong><small>Discovery</small></div><div><strong>Ops</strong><small>Execution</small></div><div><strong>Pro</strong><small>Scale</small></div></div>
          {capabilities.slice(0,3).map(([n,t,p]) => <div className="workflow-card" key={n}><span>{n}</span><div><strong>{t}</strong><p>{p}</p></div></div>)}
          <div className="panel-footer"><span>Focused workflows</span><span>Structured outputs</span><span>Global access</span></div>
        </div>
      </section>

      <section className="trust-strip" aria-label="Platform strengths">{outcomes.map(i => <span key={i}>{i}</span>)}</section>

      <section className="section-block">
        <div className="section-heading row"><div><span className="eyebrow">Explore the platform</span><h2>AI organized around business outcomes.</h2><p>Move from idea to execution with workflows designed around the job to be done, not generic chat.</p></div><Link className="text-link" href="/tools">View all tools →</Link></div>
        <div className="card-grid">{categories.map(([title,text,href]) => <Link className="feature-card" href={href} key={title}><span className="icon-box">✦</span><h3>{title}</h3><p>{text}</p><strong>Explore →</strong></Link>)}</div>
      </section>

      <section className="enterprise-band">
        <div><span className="eyebrow">Built for modern teams</span><h2>One operating layer from discovery to delivery.</h2><p>Use AXION for research, ideation, copy, SEO planning, campaign execution, sales communication and repeatable business workflows.</p></div>
        <div className="audience-cloud">{audiences.map(a => <span key={a}>{a}</span>)}</div>
      </section>

      <section className="split-section">
        <div><span className="eyebrow">Built for repeatability</span><h2>Turn isolated prompts into reliable workflows.</h2><p>AXION combines specialized generators, reusable prompts and structured templates so teams can reduce blank-page work and standardize high-value tasks.</p><div className="inline-links"><Link className="text-link" href="/templates">Browse templates →</Link><Link className="text-link" href="/prompts">Browse prompts →</Link></div></div>
        <div className="stack-card">{capabilities.map(([n,t,p]) => <div key={n}><b>{n}</b><span><strong>{t}</strong><small>{p}</small></span></div>)}</div>
      </section>

      <section className="section-block seo-section">
        <div className="section-heading centered"><span className="eyebrow">High-intent use cases</span><h2>Find AI workflows for the work you already do.</h2><p>Explore focused pages for SEO, marketing, ecommerce, sales, creators, agencies and business teams.</p></div>
        <div className="keyword-grid">
          {["AI tools for small business","AI tools for SEO teams","AI tools for content marketing","AI tools for ecommerce","AI tools for sales teams","AI tools for YouTube creators","AI tools for marketing agencies","AI tools for entrepreneurs"].map((label,i) => <Link href={["/use-cases/small-business","/use-cases/seo-teams","/use-cases/content-marketing","/use-cases/ecommerce","/use-cases/sales-teams","/use-cases/youtube-creators","/use-cases/agencies","/use-cases/entrepreneurs"][i]} key={label}>{label}<span>→</span></Link>)}
        </div>
      </section>

      <section className="cta-band"><div><span className="eyebrow">Start building</span><h2>Put AI to work on a real task.</h2><p>Explore the tool directory and turn a business objective into usable output.</p></div><div className="cta-actions"><Link className="button light" href="/tools">Open AI Tools</Link><Link className="button ghost-light" href="/pricing">View Pro</Link></div></section>
    </main>
  );
}
