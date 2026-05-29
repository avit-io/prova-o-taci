# Prova o taci

Compendio LaTeX a *Verified Functional Programming in Agda* di Aaron Stump.
Stile tipografico ClassicThesis + ArsClassica (Pantieri), copertina stile Depero.

## Struttura

```
book/
  main.tex               — preamble, copertina, nota al lettore, struttura
  parte-i-fondamenta.tex — cap. 1–4: punto di partenza, giudizi, meta vs linguaggio, schema F-I-E-C
  parte-ii-tipi.tex      — cap. 5–11: 𝔹, ℕ, Π, Π in azione, ∀, Σ, tipo identità
  parte-iii-prove.tex    — cap. 12–14: logica che affiora, Vec, &&-comm di Stump
  parte-iv-indice.tex    — ceri e decisioni di design
src/
  ch01/Booleans.agda     — esercizi cap. 1 (Iowa Agda Library)
```

## Compilazione locale

Con nix (ambiente già configurato):

```bash
nix develop
cd book
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex   # secondo pass per TOC
```

## CI

Ogni push su `main` compila il PDF e pubblica una release `latest` su GitHub.
Il workflow è in `.github/workflows/compile-pdf.yml`.

## Pacchetti LaTeX richiesti

Tutto in TeX Live full. I non scontati:

- `classicthesis` + `arsclassica` (Pantieri)
- `mathpazo` (Palatino per il testo)
- `mathpartir` (regole di inferenza con `\inferrule`)
- `listings` (codice Agda con mapping Unicode)
- `tikz` con librerie `arrows.meta, positioning, decorations.pathmorphing, calc`

Niente shell-escape, niente Lua/XeLaTeX. `pdflatex` puro.

## Unicode nei listati Agda

I simboli Unicode (𝔹, ≡, ∀, →, ⊢, ⊥, λ…) sono gestiti via `literate=` in
`book/main.tex`. Se aggiungi nuovi simboli nei listati, estendi quella lista.
