"use client";

import { useState } from "react";

export default function ToolClient({name,placeholder,system}:{name:string;placeholder:string;system:string}){
  const [input,setInput]=useState("");
  const [tone,setTone]=useState("Professional");
  const [language,setLanguage]=useState("English");
  const [output,setOutput]=useState("");
  const [error,setError]=useState("");
  const [loading,setLoading]=useState(false);

  async function generate(){
    if(!input.trim()){setError("Enter some context before generating.");return}
    setLoading(true);setError("");setOutput("");
    try{
      const response=await fetch("/api/generate",{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify({input,tone,language,system})});
      const data=await response.json();
      if(!response.ok||!data.ok)throw new Error(data.error||"Generation failed.");
      setOutput(data.output);
    }catch(e){setError(e instanceof Error?e.message:"Generation failed.")}
    finally{setLoading(false)}
  }

  async function copy(){if(output)await navigator.clipboard.writeText(output)}

  return <section className="tool-workspace" aria-label={`${name} workspace`}>
    <div className="tool-input-panel">
      <label htmlFor="tool-input">Your input</label>
      <textarea id="tool-input" value={input} onChange={e=>setInput(e.target.value)} placeholder={placeholder} rows={10}/>
      <div className="tool-controls">
        <label>Tone<select value={tone} onChange={e=>setTone(e.target.value)}><option>Professional</option><option>Direct</option><option>Persuasive</option><option>Friendly</option><option>Concise</option></select></label>
        <label>Language<select value={language} onChange={e=>setLanguage(e.target.value)}><option>English</option><option>Portuguese</option><option>Spanish</option><option>French</option><option>German</option></select></label>
      </div>
      <button className="button primary full" onClick={generate} disabled={loading}>{loading?"Generating…":"Generate with AI"}</button>
      {error&&<p className="tool-error" role="alert">{error}</p>}
    </div>
    <div className="tool-output-panel">
      <div className="output-head"><span>Output</span>{output&&<button onClick={copy}>Copy</button>}</div>
      {output?<pre>{output}</pre>:<div className="empty-output"><strong>Your generated result will appear here.</strong><p>Add useful context for a stronger result.</p></div>}
    </div>
  </section>
}
