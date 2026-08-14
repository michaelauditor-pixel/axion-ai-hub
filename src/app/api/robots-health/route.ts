export const dynamic = "force-dynamic";

export async function GET() {
  const base = "https://axionaihub.com";
  const targets = ["/robots.txt", "/sitemap.xml", "/", "/tools", "/pricing"];
  const results = await Promise.all(targets.map(async (path) => {
    try {
      const response = await fetch(`${base}${path}`, { method: "HEAD", cache: "no-store" });
      return { path, status: response.status, ok: response.ok };
    } catch (error) {
      return { path, status: 0, ok: false, error: error instanceof Error ? error.message : "fetch failed" };
    }
  }));
  return Response.json({ ok: results.every((item) => item.ok), results, checkedAt: new Date().toISOString() });
}
