const urls = ["/", "/tools", "/templates", "/prompts", "/pricing", "/about", "/contact"];

export async function GET() {
  return Response.json({
    site: "https://axionaihub.com",
    generatedAt: new Date().toISOString(),
    urls: urls.map((path) => `https://axionaihub.com${path}`),
  });
}
