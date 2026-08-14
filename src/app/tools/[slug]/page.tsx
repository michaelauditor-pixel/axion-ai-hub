import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import ToolClient from "./ToolClient";
import { getTool, toolDefinitions } from "../data";

const SITE_URL="https://axionaihub.com";

export function generateStaticParams(){return toolDefinitions.map(t=>({slug:t.slug}))}

export async function generateMetadata({params}:{params:Promise<{slug:string}>}):Promise<Metadata>{
  const {slug}=await params;const tool=getTool(slug);if(!tool)return {};
  return {title:tool.name,description:tool.description,keywords:tool.keywords,alternates:{canonical:`/tools/${tool.slug}`},openGraph:{title:tool.name,description:tool.description,url:`${SITE_URL}/tools/${tool.slug}`,type:"website"}};
}

export default async function ToolPage({params}:{params:Promise<{slug:string}>}){
  const {slug}=await params;const tool=getTool(slug);if(!tool)notFound();
  const url=`${SITE_URL}/tools/${tool.slug}`;
  const schema={"@context":"https://schema.org","@graph":[
    {"@type":"WebPage","@id":`${url}#webpage`,name:tool.name,description:tool.description,url,inLanguage:"en",isPartOf:{"@id":`${SITE_URL}/#website`},about:tool.keywords},
    {"@type":"BreadcrumbList",itemListElement:[{"@type":"ListItem",position:1,name:"Home",item:SITE_URL},{"@type":"ListItem",position:2,name:"AI Tools",item:`${SITE_URL}/tools`},{"@type":"ListItem",position:3,name:tool.name,item:url}]}
  ]};
  const related=toolDefinitions.filter(t=>t.slug!==tool.slug).slice(0,3);
  return <main className="page-shell">
    <script type="application/ld+json" dangerouslySetInnerHTML={{__html:JSON.stringify(schema)}}/>
    <nav className="breadcrumbs" aria-label="Breadcrumb"><Link href="/">Home</Link><span>›</span><Link href="/tools">AI Tools</Link><span>›</span><span>{tool.name}</span></nav>
    <section className="section-heading"><span className="eyebrow">{tool.category} AI Tool</span><h1>{tool.name}</h1><p>{tool.description}</p></section>
    <ToolClient name={tool.name} placeholder={tool.placeholder} system={tool.system}/>
    <section className="section-block"><div className="section-heading"><span className="eyebrow">Workflow guidance</span><h2>Get a stronger result with better context.</h2><p>Describe the objective, target audience, constraints, product or topic details, and the result you want. Specific inputs produce more useful outputs than generic requests.</p></div><div className="card-grid">{related.map(r=><Link className="feature-card" href={`/tools/${r.slug}`} key={r.slug}><h3>{r.name}</h3><p>{r.description}</p><strong>Open tool →</strong></Link>)}</div></section>
  </main>
}
