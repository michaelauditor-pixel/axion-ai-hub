import type { MetadataRoute } from "next";
import { useCases } from "./use-cases/data";

const SITE_URL="https://axionaihub.com";

export default function sitemap():MetadataRoute.Sitemap{
  const now=new Date();
  const core=[{path:"",p:1,c:"daily"},{path:"/tools",p:.95,c:"daily"},{path:"/use-cases",p:.92,c:"weekly"},{path:"/pricing",p:.9,c:"weekly"},{path:"/templates",p:.85,c:"weekly"},{path:"/prompts",p:.85,c:"weekly"},{path:"/about",p:.7,c:"monthly"},{path:"/contact",p:.7,c:"monthly"},{path:"/privacy-policy",p:.3,c:"yearly"},{path:"/terms-of-service",p:.3,c:"yearly"}] as const;
  const coreEntries=core.map(r=>({url:`${SITE_URL}${r.path}`,lastModified:now,changeFrequency:r.c,priority:r.p}));
  const useCaseEntries=useCases.map(item=>({url:`${SITE_URL}/use-cases/${item.slug}`,lastModified:now,changeFrequency:"monthly" as const,priority:.8}));
  return [...coreEntries,...useCaseEntries];
}
