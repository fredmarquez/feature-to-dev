// Tour script for walkthrough videos. Inject into a COPY of the prototype:
//   <script src="tour.js"></script> before </body>
// Then render each step via ?step=N (see scripts/render_walkthrough.sh).
// No Chrome or ffmpeg? Open tour.html?step=0&play=1: it plays itself step by step, ready for a screen recording.
// Assumes the prototype exposes top-level globals (classic script, not a module): S (state), render(), fit(), scale,
// and optionally renderMenu().
// Fill in STEPS below. setup() sets state DIRECTLY: never replay clicks.

// Headless Chrome resizes the viewport after load; stop the prototype's resize handler from resetting state.
window.addEventListener('resize', e => e.stopImmediatePropagation(), true);

(async function(){
await document.fonts.ready; await new Promise(r => setTimeout(r, 700));

// Force 1:1 scale so element positions are stable regardless of the viewport.
fit = function(){ scale = 1;
  document.querySelectorAll('[data-tour-scale]').forEach(el => el.style.transform = 'none'); };
// ↑ Mark the scaled frame(s) in the prototype with data-tour-scale, or replace this body with the prototype's own elements.

const params = new URLSearchParams(location.search);
const step = +(params.get('step') || 0);

// Brand: ALWAYS replace these neutral defaults with the project profile's "Video branding".
const BRAND = {
  bg: '#18181B',        // caption bar + page background
  text: '#FFFFFF',
  muted: '#A1A1AA',     // caption subtitle
  accent: '#3B82F6',    // step number + highlight ring
  accentText: '#FFFFFF',
  card: 'linear-gradient(135deg,#1E293B 0%,#334155 100%)', // intro/outro background
  font: 'system-ui,sans-serif'
};

const css = document.createElement('style');
css.textContent = `
:root{--t-bg:${BRAND.bg};--t-text:${BRAND.text};--t-muted:${BRAND.muted};--t-accent:${BRAND.accent};--t-accent-text:${BRAND.accentText};--t-card:${BRAND.card};--t-font:${BRAND.font}}
/* hide prototype chrome */ .bar,.notes{display:none!important}
body{background:var(--t-bg)}
.stage{padding:20px 0 0;align-items:flex-start}
#cap{position:fixed;left:0;right:0;bottom:0;height:120px;display:flex;align-items:center;gap:22px;padding:0 60px;background:var(--t-bg);color:var(--t-text);font-family:var(--t-font)}
#cap .n{width:44px;height:44px;border-radius:50%;background:var(--t-accent);color:var(--t-accent-text);display:grid;place-items:center;font-weight:700;font-size:18px;flex:0 0 44px}
#cap .t{font-size:22px;font-weight:600;letter-spacing:-.01em}
#cap .s{font-size:15px;color:var(--t-muted);margin-top:4px}
#cur{position:absolute;width:26px;height:26px;z-index:999;pointer-events:none;filter:drop-shadow(0 2px 3px rgba(0,0,0,.35))}
#ring{position:absolute;width:46px;height:46px;border-radius:50%;border:3px solid var(--t-accent);z-index:998;pointer-events:none;transform:translate(-50%,-50%)}
/* forced hover states: copy the prototype's tooltip/hover styles here */
[data-tip].tipon::after{content:attr(data-tip);position:absolute;bottom:calc(100% + 7px);left:50%;transform:translateX(-50%);background:#262626;color:#fff;font-size:12px;font-weight:500;padding:6px 9px;border-radius:8px;white-space:nowrap;z-index:60}
[data-tip][data-tip-pos=below].tipon::after{bottom:auto;top:calc(100% + 7px)}
#card{position:fixed;inset:0;z-index:1000;background:var(--t-card);display:flex;flex-direction:column;justify-content:center;padding:0 140px;color:var(--t-text);font-family:var(--t-font)}
#card .k{font-size:16px;font-weight:600;letter-spacing:.12em;text-transform:uppercase;opacity:.85}
#card h1{font-size:64px;font-weight:700;letter-spacing:-.03em;margin:14px 0 18px}
#card p{font-size:22px;line-height:1.5;max-width:900px;margin:0}
#card ul{font-size:20px;line-height:1.7;margin:22px 0 0;padding-left:24px}
#missing{position:fixed;top:0;left:0;right:0;z-index:1001;background:#DC2626;color:#fff;font:600 18px/1.4 system-ui,sans-serif;padding:12px 24px}`;
document.head.appendChild(css);

// ---------------- EDIT ME ----------------
const STEPS = [
  {card:'intro'},
  // Examples:
  // {cap:['The banner shows on first visit','Hidden after the user dismisses it once.'],
  //  setup(){ S.firstVisit=true; }, target:'.banner', hover:'.banner'},
  // {cap:['Pick a filter','Category first, then the value.'], setup(){ S.menu={anchor:'filter',group:'status'}; }, menu:true, target:'[data-group=status]'},
  // {cap:['Tooltip example','…'], setup(){}, target:'[data-act=save]', tip:true},
  {card:'outro'}
];
const CARDS = {
  intro: `<div class="k">Product · Prototype walkthrough</div><h1>Feature name</h1><p>One-sentence value statement.</p>`,
  outro: `<div class="k">Rules recap</div><h1>Feature name</h1><ul><li>Rule 1</li><li>Rule 2</li></ul>`
};
// Called after render() for steps with menu:true: position and lock the popover open.
function openMenuForTour(){
  if (typeof renderMenu !== 'function' || !S.menu) return;
  renderMenu();
  const M = S.menu; Object.defineProperty(S, 'menu', {get(){return M}, set(v){}, configurable:true});
}
// -----------------------------------------

if (!Number.isInteger(step) || step < 0 || step >= STEPS.length) {
  const error = document.createElement("p"); error.textContent = "Unknown tour step"; document.body.appendChild(error); return;
}
const st = STEPS[step];
// Autoplay (?play=1): hold each step, then move to the next one. Same timings as the render script.
if (params.get('play') === '1' && step < STEPS.length - 1)
  setTimeout(() => location.replace(`?step=${step + 1}&play=1`), st.card ? 4500 : 3800);
if (st.card){ const c=document.createElement('div'); c.id='card'; c.innerHTML=CARDS[st.card]; document.body.appendChild(c); return; }
st.setup && st.setup();
render(false);
fit();
if (st.scroll) st.scroll();               // optional: function that scrolls containers into place
if (st.menu) openMenuForTour();
if (st.hover) document.querySelector(st.hover)?.classList.add('hov');

const cap=document.createElement('div'); cap.id='cap';
cap.innerHTML='<div class="n"></div><div><div class="t"></div><div class="s"></div></div>';
cap.querySelector(".n").textContent = String(step);
cap.querySelector(".t").textContent = st.cap[0];
cap.querySelector(".s").textContent = st.cap[1];
document.body.appendChild(cap);

if (st.target){
  const el=document.querySelector(st.target);
  // A selector that matches nothing shows a red banner, so the contact sheet catches it.
  if (!el){ const m=document.createElement('div'); m.id='missing'; m.textContent='MISSING target: '+st.target; document.body.appendChild(m); return; }
  if (st.tip) el.classList.add('tipon');
  const r=el.getBoundingClientRect(), x=r.left+scrollX+Math.min(r.width/2,60), y=r.top+scrollY+r.height/2;
  const ring=document.createElement('div'); ring.id='ring'; ring.style.left=x+'px'; ring.style.top=y+'px'; document.body.appendChild(ring);
  const c=document.createElement('div'); c.id='cur'; c.style.left=(x-4)+'px'; c.style.top=(y-2)+'px';
  c.innerHTML='<svg viewBox="0 0 24 24" width="26" height="26"><path d="M4 2l16 9-7 1.6L9.6 20z" fill="#111" stroke="#fff" stroke-width="1.6" stroke-linejoin="round"/></svg>';
  document.body.appendChild(c);
}
})();
