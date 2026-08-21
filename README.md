# CoDIN Press publications portal

Quarto source for the CoDIN Press catalogue at <https://publications.diversity.org.in/>.

## Local development

Install a current Quarto release, then run:

```powershell
./scripts/validate.ps1
quarto preview
```

The generated site is written to `_site/`. Pull requests build a downloadable preview; merges to `main` deploy through GitHub Pages.

## Required GitHub setup

1. Rename this repository from `codin-publications.github.io` to `CoDIN-Press.github.io` under the `CoDIN-Press` organization.
2. Update this clone after the rename:

   ```powershell
   git remote set-url origin https://github.com/CoDIN-Press/CoDIN-Press.github.io.git
   ```

3. In repository **Settings → Pages**, select **GitHub Actions** as the publishing source.
4. Set the custom domain to `publications.diversity.org.in`.
5. In the organization’s **Settings → Pages**, verify `diversity.org.in` using GitHub’s TXT record and retain it.
6. At the DNS provider, create `publications CNAME CoDIN-Press.github.io`. Remove conflicts and avoid wildcard records.
7. After certificate provisioning, enable **Enforce HTTPS**.

## DPFA project site

Fork the completed manual into `CoDIN-Press/dpfa-manual`. Enable GitHub Actions as its Pages source and do not configure a repository-level custom domain. The organization domain will expose it at <https://publications.diversity.org.in/dpfa-manual/>.

The fork must include the portal-path integration changes from the source manual: its canonical URLs, sitemap and repository links target `/dpfa-manual/`, and its build does not publish a `CNAME`.

## Publication records

See [CONTRIBUTING.md](CONTRIBUTING.md) and `templates/publication-template.qmd.example`. ISBNs and DOIs may remain blank until assigned.

## Recovery

- For deployment failures, inspect **Actions → Publish portal** and the pull-request preview.
- For domain failures, confirm the Pages domain, DNS CNAME and organization domain verification.
- If a project opens at `CoDIN-Press.github.io/<repo>`, confirm the organization custom domain and remove project-level domain overrides.
