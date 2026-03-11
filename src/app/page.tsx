export default function HomePage() {
  return (
    <main style={{ minHeight: "100vh", background: "#ffffff", color: "#111827" }}>
      <section style={{ maxWidth: "1100px", margin: "0 auto", padding: "72px 24px 40px 24px" }}>
        <div style={{ display: "inline-block", padding: "8px 14px", border: "1px solid #e5e7eb", borderRadius: "999px", fontSize: "14px", color: "#374151", marginBottom: "24px" }}>
          AXION AI HUB
        </div>

        <h1 style={{ fontSize: "56px", lineHeight: "1.05", fontWeight: 800, margin: "0 0 20px 0", letterSpacing: "-0.03em", maxWidth: "900px" }}>
          Global AI Tools Platform for creators, marketers, founders and teams
        </h1>

        <p style={{ fontSize: "20px", lineHeight: "1.7", color: "#4b5563", maxWidth: "820px", margin: "0 0 28px 0" }}>
          Discover practical AI tools, prompts, templates and workflows designed to help you create faster,
          work smarter and scale globally.
        </p>

        <div style={{ display: "flex", gap: "14px", flexWrap: "wrap", marginBottom: "34px" }}>
          <a href="/about" style={{ padding: "14px 20px", borderRadius: "12px", background: "#111827", color: "#ffffff", textDecoration: "none", fontWeight: 600 }}>
            Explore the platform
          </a>
          <a href="/contact" style={{ padding: "14px 20px", borderRadius: "12px", border: "1px solid #d1d5db", color: "#111827", textDecoration: "none", fontWeight: 600 }}>
            Contact us
          </a>
        </div>

        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit,minmax(220px,1fr))", gap: "16px", marginTop: "28px" }}>
          <div style={{ border: "1px solid #e5e7eb", borderRadius: "18px", padding: "20px" }}>
            <div style={{ fontSize: "14px", color: "#6b7280", marginBottom: "8px" }}>Category</div>
            <div style={{ fontSize: "20px", fontWeight: 700 }}>AI Tools</div>
            <p style={{ color: "#4b5563", lineHeight: "1.6" }}>Useful AI tools built for real-world content, growth and productivity.</p>
          </div>

          <div style={{ border: "1px solid #e5e7eb", borderRadius: "18px", padding: "20px" }}>
            <div style={{ fontSize: "14px", color: "#6b7280", marginBottom: "8px" }}>Library</div>
            <div style={{ fontSize: "20px", fontWeight: 700 }}>Prompts & Templates</div>
            <p style={{ color: "#4b5563", lineHeight: "1.6" }}>Structured prompt systems and reusable templates for multiple workflows.</p>
          </div>

          <div style={{ border: "1px solid #e5e7eb", borderRadius: "18px", padding: "20px" }}>
            <div style={{ fontSize: "14px", color: "#6b7280", marginBottom: "8px" }}>SEO</div>
            <div style={{ fontSize: "20px", fontWeight: 700 }}>Search-Ready Pages</div>
            <p style={{ color: "#4b5563", lineHeight: "1.6" }}>Built to support indexation, discoverability and scalable organic growth.</p>
          </div>

          <div style={{ border: "1px solid #e5e7eb", borderRadius: "18px", padding: "20px" }}>
            <div style={{ fontSize: "14px", color: "#6b7280", marginBottom: "8px" }}>Global</div>
            <div style={{ fontSize: "20px", fontWeight: 700 }}>Worldwide Expansion</div>
            <p style={{ color: "#4b5563", lineHeight: "1.6" }}>Designed for multilingual growth, international traffic and AI-first scale.</p>
          </div>
        </div>
      </section>

      <section style={{ maxWidth: "1100px", margin: "0 auto", padding: "20px 24px 32px 24px" }}>
        <h2 style={{ fontSize: "34px", fontWeight: 800, margin: "0 0 18px 0" }}>Featured areas</h2>

        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit,minmax(280px,1fr))", gap: "18px" }}>
          <a href="/about" style={{ textDecoration: "none", color: "#111827", border: "1px solid #e5e7eb", borderRadius: "18px", padding: "22px", display: "block" }}>
            <div style={{ fontSize: "22px", fontWeight: 700, marginBottom: "10px" }}>About AXION AI HUB</div>
            <div style={{ color: "#4b5563", lineHeight: "1.6" }}>Learn what the platform is building and how the ecosystem is designed to scale.</div>
          </a>

          <a href="/privacy-policy" style={{ textDecoration: "none", color: "#111827", border: "1px solid #e5e7eb", borderRadius: "18px", padding: "22px", display: "block" }}>
            <div style={{ fontSize: "22px", fontWeight: 700, marginBottom: "10px" }}>Privacy Policy</div>
            <div style={{ color: "#4b5563", lineHeight: "1.6" }}>Read how user information, analytics data and usage patterns are handled.</div>
          </a>

          <a href="/terms-of-service" style={{ textDecoration: "none", color: "#111827", border: "1px solid #e5e7eb", borderRadius: "18px", padding: "22px", display: "block" }}>
            <div style={{ fontSize: "22px", fontWeight: 700, marginBottom: "10px" }}>Terms of Service</div>
            <div style={{ color: "#4b5563", lineHeight: "1.6" }}>Review the platform terms, permitted usage and service conditions.</div>
          </a>
        </div>
      </section>

      <section style={{ maxWidth: "1100px", margin: "0 auto", padding: "12px 24px 80px 24px" }}>
        <div style={{ border: "1px solid #e5e7eb", borderRadius: "24px", padding: "28px", background: "#fafafa" }}>
          <h2 style={{ fontSize: "30px", fontWeight: 800, margin: "0 0 12px 0" }}>Built for long-term growth</h2>
          <p style={{ color: "#4b5563", fontSize: "18px", lineHeight: "1.7", maxWidth: "860px" }}>
            AXION AI HUB is being developed as a scalable platform for AI tools, prompt systems, templates,
            examples and programmatic content infrastructure.
          </p>

          <div style={{ display: "flex", gap: "12px", flexWrap: "wrap", marginTop: "22px" }}>
            <a href="/contact" style={{ padding: "12px 18px", borderRadius: "12px", background: "#111827", color: "#fff", textDecoration: "none", fontWeight: 600 }}>
              Contact
            </a>
            <a href="/about" style={{ padding: "12px 18px", borderRadius: "12px", border: "1px solid #d1d5db", color: "#111827", textDecoration: "none", fontWeight: 600 }}>
              Learn more
            </a>
          </div>
        </div>
      </section>
    </main>
  );
}
