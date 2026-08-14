import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { getUseCase, useCases } from "../data";

const SITE_URL = "https://axionaihub.com";

export function generateStaticParams(){return useCases.map(item=>({slug:item.slug}))}

export async function generateMetadata({params}:{params:Promise<{slug:string}>}):Promise<Metadata>{
  const {slug}=await params;
  const item=getUseCase(slug);
  if(!item)return {};
  return {
    title:item.title,
    description:item.description,
    keywords:item.keywords,
    alternates:{canonical:`/use-cases/${item.slug}`},
    openGraph:{title:item.title,description:item.description,url:`${SITE_URL}/use-cases/${item.slug}`,type:"article"},
    twitter:{card:"summary_large_image",title:item.title,description:item.description},
  };
}

export default async function UseCasePage({params}:{params:Promise<{slug:string}>}){
  const {slug}=await params;
  const item=getUseCase(slug);
  if(!item)notFound();
  const currentIndex=useCases.findIndex(x=>x.slug===item.slug);
  const related=useCases.filter((_,i)=>i!==currentIndex).slice((currentIndex*3)%Math.max(1,useCases.length-6),(currentIndex*3)%Math.max(1,useCases.length-6)+6);
  const schema={"@context":"https://schema.org","@graph":[
    {"@type":"WebPage","@id":`${SITE_URL}/use-cases/${item.slug}#webpage`,name:item.title,description:item.description,url:`${SITE_URL}/use-cases/${item.slug}`,about:item.keywords,inLanguage:"en",isPartOf:{"@id":`${SITE_URL}/#website`}},
    {"@type":"BreadcrumbList",itemListElement:[{"@type":"ListItem",position:1,name:"Home",item:SITE_URL},{"@type":"ListItem",position:2,name:"Use cases",item:`${SITE_URL}/use-cases`},{"@type":"ListItem",position:3,name:item.title,item:`${SITE_URL}/use-cases/${item.slug}`}]}
  ]};
  return <main className="page-shell">
    <script type="application/ld+json" dangerouslySetInnerHTML={{__html:JSON.stringify(schema)}}/>
    <nav className="breadcrumbs" aria-label="Breadcrumb"><Link href="/">Home</Link><span>›</span><Link href="/use-cases">Use cases</Link><span>›</span><span>{item.title}</span></nav>
    <section className="section-heading"><span className="eyebrow">{item.audience}</span><h1>{item.title}</h1><p>{item.description}</p><div className="hero-actions"><Link className="button primary" href="/tools">Explore AI tools</Link><Link className="button secondary" href="/use-cases">All use cases</Link></div></section>
    <section className="card-grid">
      <article className="feature-card"><span className="icon-box">01</span><h2>What this workflow helps you improve</h2><ul className="feature-list">{item.outcomes.map(value=><li key={value}>{value}</li>)}</ul></article>
      <article className="feature-card"><span className="icon-box">02</span><h2>Common workflows</h2><ul className="feature-list">{item.workflows.map(value=><li key={value}>{value}</li>)}</ul></article>
      <article className="feature-card"><span className="icon-box">03</span><h2>How to use AXION</h2><p>Start with a specific task, identify the audience and desired outcome, choose the closest workflow, then refine the generated result with concrete constraints, examples and channel requirements.</p></article>
    </section>
    <section className="split-section"><div><span className="eyebrow">From prompt to process</span><h2>Use AI as a repeatable workflow, not a one-off answer.</h2><p>Define the objective, add relevant context, generate a structured first version and refine it against the real business constraint. Save the winning pattern as a reusable prompt or template for consistent execution.</p></div><div className="stack-card">{["Define the job and target audience","Add product, market or channel context","Generate multiple usable directions","Refine and reuse the strongest workflow"].map((x,i)=><div key={x}><b>0{i+1}</b><span><strong>{x}</strong><small>Keep the input specific and measurable.</small></span></div>)}</div></section>
    <section className="section-block"><div className="section-heading"><span className="eyebrow">Related workflows</span><h2>Explore adjacent AI use cases.</h2><p>Build internal workflow coverage across functions and channels.</p></div><div className="card-grid">{related.map(r=><Link className="feature-card" href={`/use-cases/${r.slug}`} key={r.slug}><h3>{r.title}</h3><p>{r.description}</p><strong>Explore →</strong></Link>)}</div></section>
    <section className="cta-band"><div><span className="eyebrow">Practical AI</span><h2>Move from a blank page to a usable first version faster.</h2></div><Link className="button light" href="/tools">Open the tool directory</Link></section>
  </main>
}
