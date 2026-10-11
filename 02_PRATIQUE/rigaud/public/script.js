const cartes = [...document.querySelectorAll('.carte')];
const boxQ = [...document.querySelectorAll('input.q')];
const boxP = [...document.querySelectorAll('input.p')];
const DUREE = 350; // = durée de la transition CSS .carte

// Retournement au clic
document.querySelectorAll('.carte-inner').forEach(b =>
  b.addEventListener('click', () => {
    b.setAttribute('aria-pressed', String(b.getAttribute('aria-pressed') !== 'true'));
  }));

// Quadrille : coche tous ses personnages
boxQ.forEach(q => q.addEventListener('change', () => {
  q.indeterminate = false;
  boxP.filter(p => p.dataset.parent === q.value).forEach(p => p.checked = q.checked);
  filtrer();
}));

// Personnage : met à jour l'état du quadrille (coché / indéterminé)
boxP.forEach(p => p.addEventListener('change', () => {
  const freres = boxP.filter(x => x.dataset.parent === p.dataset.parent);
  const q = boxQ.find(x => x.value === p.dataset.parent);
  q.checked = freres.every(x => x.checked);
  q.indeterminate = !q.checked && freres.some(x => x.checked);
  filtrer();
}));

// Les cases dans <summary> ne doivent pas replier le <details>
document.querySelectorAll('summary label').forEach(l =>
  l.addEventListener('click', e => e.stopPropagation()));

document.getElementById('tout').addEventListener('click', () => {
  [...boxQ, ...boxP].forEach(b => { b.checked = false; b.indeterminate = false; });
  filtrer();
});

function filtrer() {
  const choisis = new Set(boxP.filter(p => p.checked).map(p => p.value));
  const tout = choisis.size === 0; // rien de coché = tout afficher
  cartes.forEach(c => {
    const visible = tout || choisis.has(c.dataset.personnage);
    clearTimeout(c._t);
    if (visible) {
      c.classList.remove('retiree');
      requestAnimationFrame(() => requestAnimationFrame(() => c.classList.remove('masquee')));
    } else {
      c.classList.add('masquee');
      c._t = setTimeout(() => c.classList.add('retiree'), DUREE);
    }
  });
}

// Bandeau des lettres (page alphabétique)
document.querySelectorAll('.lettre').forEach(btn =>
  btn.addEventListener('click', () => {
    const q = boxQ.find(x => x.value === 'l-' + btn.dataset.lettre);
    if (!q) return;
    q.checked = !q.checked;
    q.dispatchEvent(new Event('change'));
    btn.classList.toggle('active', q.checked);
    document.getElementById('lettre-' + btn.dataset.lettre)?.scrollIntoView({ block: 'nearest' });
  }));