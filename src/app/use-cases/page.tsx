import type { Metadata } from "next";
import Link from "next/link";
import { useCases } from "./data";

export const metadata:Metadata={title:"AI Use Cases",description:"Explore practical AI use cases for SEO, marketing, sales, ecommerce, creators, agencies, startups and productivity.",alternates:{canonical:"/use-cases"}};

export default function UseCasesPage(){return <main className="page-shell"><section className="section-heading centered"><span className="eyebrow">AI by workflow</span><h1>Find the right AI workflow for the work you actually do.</h1><p>Explore focused use cases built around real search, marketing, content, sales and business tasks.</p></section><section className="card-grid">{useCases.map(item=><article className="feature-card" key={item.slug}><span className="eyebrow">{item.audience}</span><h2>{item.title}</h2><p>{item.description}</p><Link className="text-link" href={`/use-cases/${item.slug}`}>Explore workflow →</Link></article>)}</section><section className="cta-band"><div><span className="eyebrow">Start working</span><h2>Use AXION tools to turn intent into output.</h2></div><Link className="button light" href="/tools">Browse AI tools</Link></section></main>}
