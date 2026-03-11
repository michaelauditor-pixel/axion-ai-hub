export default function Home() {
  return (
    <main style={{ padding: "60px", fontFamily: "Arial, sans-serif" }}>
      <h1>AXION AI HUB</h1>
      <p>Global AI tools platform.</p>
      <p>This homepage is now working correctly.</p>
      <nav style={{ display: "flex", gap: "12px", flexWrap: "wrap", marginTop: "20px" }}>
        <a href="/about">About</a>
        <a href="/contact">Contact</a>
        <a href="/privacy-policy">Privacy Policy</a>
        <a href="/terms-of-service">Terms of Service</a>
      </nav>
    </main>
  );
}
