export default function Home() {
  return (
    <main style={{ padding: "60px", maxWidth: "1000px", margin: "0 auto" }}>
      <h1 style={{ fontSize: "48px", marginBottom: "16px" }}>AXION AI HUB</h1>
      <p style={{ fontSize: "20px", color: "#444", marginBottom: "24px" }}>
        Global AI tools platform for creators, marketers, founders and teams.
      </p>

      <div style={{ display: "flex", gap: "12px", flexWrap: "wrap", marginBottom: "28px" }}>
        <a href="/about">About</a>
        <a href="/contact">Contact</a>
        <a href="/privacy-policy">Privacy Policy</a>
        <a href="/terms-of-service">Terms of Service</a>
      </div>

      <section style={{ display: "grid", gap: "16px" }}>
        <div style={{ border: "1px solid #ddd", borderRadius: "12px", padding: "20px" }}>
          <h2>AI Tools</h2>
          <p>Practical tools, prompts and templates for real-world workflows.</p>
        </div>

        <div style={{ border: "1px solid #ddd", borderRadius: "12px", padding: "20px" }}>
          <h2>SEO-Ready Platform</h2>
          <p>Built for scalable growth, organic traffic and global AI distribution.</p>
        </div>

        <div style={{ border: "1px solid #ddd", borderRadius: "12px", padding: "20px" }}>
          <h2>Next Step</h2>
          <p>The platform is being expanded into a complete AI tools ecosystem.</p>
        </div>
      </section>
    </main>
  );
}
