export const dynamic = "force-dynamic";

export async function GET() {
  return Response.json({
    ok: true,
    service: "axion-ai-hub",
    status: "healthy",
    timestamp: new Date().toISOString(),
  });
}
