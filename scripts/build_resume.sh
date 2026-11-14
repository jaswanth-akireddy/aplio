#!/usr/bin/env bash
# build_resume.sh <path/to/resume.tex>
# Compiles a tailored resume next to its .tex, then checks:
#   - exactly one page
#   - contact details extract as plain text (what an ATS parser reads)
#   - no broken glyphs and no words hyphen-split across lines
# Writes <name>.txt (the extracted text) beside the PDF. Exit code 1 on any failure.
set -euo pipefail
TEX="${1:?usage: build_resume.sh <resume.tex>}"
DIR="$(cd "$(dirname "$TEX")" && pwd)"
BASE="$(basename "${TEX%.tex}")"
cd "$DIR"

for i in 1 2; do
  pdflatex -interaction=nonstopmode -halt-on-error "$BASE.tex" > "$BASE.compile.log" 2>&1 || {
    echo "FAIL: LaTeX error"; grep -E '^!' -A3 "$BASE.compile.log" | head -20; exit 1; }
done

PAGES=$(pdfinfo "$BASE.pdf" | awk '/^Pages/{print $2}')
pdftotext "$BASE.pdf" "$BASE.txt"
rm -f "$BASE.aux" "$BASE.log" "$BASE.out" "$BASE.compile.log"

FAIL=0
[ "$PAGES" = "1" ] || { echo "FAIL: $PAGES pages (must be 1)"; FAIL=1; }
for needle in "jaswanthakireddy01@gmail.com" "+91-9666735445" "linkedin.com/in/jaswanth-akireddy" "github.com/jaswanth-akireddy" \
              "Summary" "Skills" "Work Experience" "Education"; do
  grep -qF "$needle" "$BASE.txt" || { echo "FAIL: '$needle' not found in extracted text"; FAIL=1; }
done
if grep -qF $'\xEF\xBF\xBD' "$BASE.txt"; then echo "FAIL: broken glyphs in text layer"; FAIL=1; fi
SPLIT=$(grep -cP '[a-z]-$' "$BASE.txt" || true)
[ "$SPLIT" = "0" ] || echo "WARN: $SPLIT line(s) end in a hyphen; check for split words"

WORDS=$(wc -w < "$BASE.txt")
echo "pages=$PAGES words=$WORDS -> $DIR/$BASE.pdf"
exit $FAIL
