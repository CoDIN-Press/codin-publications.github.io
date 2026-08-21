# Adding a publication

1. Copy `templates/publication-template.qmd.example` to `publications/<catalogue-slug>/index.qmd`.
2. Add an approved cover under `assets/covers/` and supply meaningful alt text.
3. Complete every required metadata field. Blank ISBN and DOI values are allowed; never invent identifier-like placeholders.
4. Use categories for publication type, languages, subjects and year so filters remain useful.
5. Add the publication to the appropriate type page and confirm all URLs use its canonical repository route.
6. Run `./scripts/validate.ps1` and `quarto render`, then inspect the card and detail page.
7. Open a pull request and review its preview artifact before merging.

Publication records do not override the rights, consent or cultural conditions stated by the publication itself.
