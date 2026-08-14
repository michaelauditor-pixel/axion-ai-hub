export const dynamic = "force-dynamic";

export async function GET() {
  const base = "https://axionaihub.com";
  const targets = ["/", "/tools", "/templates", "/prompts", "/pricing", "/about", "/contact"];
  const checks = await Promise.all(targets.map(async (path) => {
    try {
      const response = await fetch(`${base}${path}`, { cache: "no-store" });
      const html = await response.text();
      return {
        path,
        status: response.status,
        canonical: /rel=["']canonical["']/i.test(html),
        title: /<title>[^<]+<\/title>/i.test(html),
        description: /<meta[^>]+name=["']description["']/i.test(html),
      };
    } catch {
      return { path, status: 0, canonical: false, title: false, description: false };
    }
  }));
  return Response.json({ ok: checks.every((c) => c.status === 200 && c.title && c.description), checks, checkedAt: new Date().toISOString() });
}
