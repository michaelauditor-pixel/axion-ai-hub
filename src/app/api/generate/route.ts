export const runtime = "nodejs";
export const dynamic = "force-dynamic";

const ROUTER = "https://router.huggingface.co/v1/chat/completions";
const DEFAULT_MODEL = "Qwen/Qwen2.5-7B-Instruct";

export async function POST(request: Request) {
  try {
    const body = await request.json().catch(() => ({}));
    const input = String(body.input || "").trim();
    const system = String(body.system || "You are a practical AI assistant.").slice(0, 4000);
    const tone = String(body.tone || "Professional");
    const language = String(body.language || "English");
    if (!input) return Response.json({ ok:false, error:"Input is required." }, { status:400 });
    if (input.length > 12000) return Response.json({ ok:false, error:"Input is too long." }, { status:413 });

    const token = process.env.HF_TOKEN || process.env.HUGGINGFACE_API_KEY || process.env.HUGGING_FACE_API_KEY || process.env.HUGGINGFACEHUB_API_TOKEN;
    if (!token) return Response.json({ ok:false, error:"AI provider is not configured." }, { status:503 });

    const model = process.env.HF_MODEL || process.env.AXION_HF_MODEL || DEFAULT_MODEL;
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 60000);
    const response = await fetch(ROUTER, {
      method:"POST",
      signal:controller.signal,
      headers:{ Authorization:`Bearer ${token}`, "Content-Type":"application/json" },
      body:JSON.stringify({
        model,
        messages:[
          { role:"system", content:`${system}\nLanguage: ${language}. Tone: ${tone}. Return only the useful final output.` },
          { role:"user", content:input }
        ],
        max_tokens:700,
        temperature:0.65,
      })
    }).finally(() => clearTimeout(timeout));

    const data = await response.json().catch(() => ({}));
    if (!response.ok) return Response.json({ ok:false, error:data?.error || "AI provider request failed.", providerStatus:response.status }, { status:502 });
    const output = data?.choices?.[0]?.message?.content;
    if (!output) return Response.json({ ok:false, error:"The AI provider returned an empty response." }, { status:502 });
    return Response.json({ ok:true, output, model });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Generation failed.";
    return Response.json({ ok:false, error:message }, { status:500 });
  }
}
