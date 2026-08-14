const SITE_URL = "https://axionaihub.com";
const HOST = "axionaihub.com";
const KEY = "c975cd84baa4601593072499fc5c2f39";
const KEY_LOCATION = `${SITE_URL}/${KEY}.txt`;

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

function normalizeUrl(value: string) {
  try {
    const url = new URL(value, SITE_URL);
    if (url.hostname !== HOST) return null;
    url.hash = "";
    return url.toString();
  } catch {
    return null;
  }
}

export async function GET() {
  return Response.json({ ok: true, service: "IndexNow", keyLocation: KEY_LOCATION, maxBatch: 10000 });
}

export async function POST(req: Request) {
  try {
    const body = await req.json().catch(() => ({}));
    const raw = Array.isArray(body.urls) ? body.urls : body.url ? [body.url] : [];
    const urlList = raw.map((url: unknown) => normalizeUrl(String(url))).filter(Boolean).slice(0, 10000) as string[];

    if (!urlList.length) {
      return Response.json({ ok: false, error: "Provide at least one axionaihub.com URL." }, { status: 400 });
    }

    const response = await fetch("https://api.indexnow.org/indexnow", {
      method: "POST",
      headers: { "Content-Type": "application/json; charset=utf-8" },
      body: JSON.stringify({ host: HOST, key: KEY, keyLocation: KEY_LOCATION, urlList }),
    });

    const text = await response.text();
    return Response.json({ ok: response.ok || response.status === 202, status: response.status, submitted: urlList.length, response: text || null }, { status: response.ok || response.status === 202 ? 200 : 502 });
  } catch (error) {
    return Response.json({ ok: false, error: error instanceof Error ? error.message : "IndexNow request failed" }, { status: 500 });
  }
}
