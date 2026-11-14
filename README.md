# Aplio: job applications

Dashboard: https://jaswanth-akireddy.github.io/aplio/

A tailored, ATS-optimized one-page resume for every job I apply to, generated on a schedule.

## How it works
1. **Add a job:** open a "New job" issue (dashboard button) with the posting link and description.
2. **Scheduled run:** Claude tailors `master/master_resume.tex` to the posting, compiles it with
   LaTeX, checks it is one page and parses cleanly, and commits it to `jobs/<slug>/`.
   The procedure is in [TAILORING.md](TAILORING.md).
3. **Ready:** the issue gets a comment with the PDF link, match score and gaps, and the
   label changes from `queued` to `ready`. The dashboard lists it.
4. **Track:** label the issue `applied`, `interviewing`, `offer` or `rejected`; the next run syncs it.

## Files
| Path | What |
|---|---|
| `index.html` | Dashboard (GitHub Pages) |
| `master/master_resume.tex` | Master resume (source of truth) |
| `master/profile.md` | Extra true facts, confirmed skills, and skills never to claim |
| `data/jobs.json`, `data/companies.json` | Dashboard data, written by the run |
| `jobs/<slug>/` | Tailored `.tex`, `.pdf`, extracted text, and `report.md` per job |
| `scripts/build_resume.sh` | Compile + one-page + ATS text checks |
| `TAILORING.md` | Instructions each scheduled run follows |

Only issues opened by `jaswanth-akireddy` are processed.
