# Aplio

Tailored, ATS-optimized one-page resumes for every job I apply to.
Dashboard: https://jaswanth-akireddy.github.io/aplio/ (sign-in required)

- **Website:** `index.html` on GitHub Pages. Sign-in and data via Supabase (owner-only, row-level security).
- **Generation:** a scheduled Claude run (8:37 AM and 5:37 PM IST) follows [TAILORING.md](TAILORING.md):
  it reads queued jobs from Supabase, tailors the master resume, compiles it with LaTeX
  (`scripts/build_resume.sh`), and records the result.
- **Files:** resumes are stored in `files/` **encrypted** (AES-256-GCM, `scripts/seal.py`).
  The key lives in Supabase, so only the signed-in owner's browser can open them.

No personal data is stored in this repo in readable form.
