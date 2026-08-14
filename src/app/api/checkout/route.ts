const FALLBACK = "https://axionaihub.com/pricing";

function checkoutUrl(){
  const value=process.env.STRIPE_PAYMENT_LINK_MONTHLY || process.env.NEXT_PUBLIC_STRIPE_PAYMENT_LINK_MONTHLY || "";
  return /^https:\/\/buy\.stripe\.com\//.test(value) ? value : null;
}

export async function GET(){const url=checkoutUrl();if(!url)return Response.redirect(`${FALLBACK}?checkout=unavailable`,302);return Response.redirect(url,302)}
export async function POST(){const url=checkoutUrl();if(!url)return Response.json({ok:false,error:"Checkout is temporarily unavailable."},{status:503});return Response.json({ok:true,url})}
