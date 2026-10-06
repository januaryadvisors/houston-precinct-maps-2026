# Voting deserts and 2026 precincts

Public maps of January Advisors voting deserts in Harris, Fort Bend, and Montgomery counties, overlaid on 2026 precinct boundaries. Built for the Voter Engagement Project evaluation team. Live site: <https://januaryadvisors.github.io/houston-precinct-maps-2026/>

This repo holds only derived, aggregate files. The analysis lives in the private `houston-voter-data` repo (`rscripts/data-requests/precincts-2026-deserts.R`). That script writes `data/web/` and `data/downloads/` here.

## Rebuild

1. In `houston-voter-data`, run `rscripts/data-requests/precincts-2026-deserts.R`. This repo must be cloned as a sibling folder.
2. Here, run `Rscript R/build-pages.R`. It writes one stub page per desert into `deserts/`.
3. Run `quarto render`. Output goes to `docs/`, which GitHub Pages serves from `main`.

The basemap uses the JA Carto key (`CARTO_API_KEY` in `.Renviron`). The key is restricted to JA domains, so tiles stay blank when you preview on localhost.

## Sources

- 2026 precincts: Texas Legislative Council, Precincts26P (March 2026 primary), <https://data.capitol.texas.gov/dataset/precincts>
- 2020 precincts: Texas Legislative Council, Precincts20G
- Adults 18+: 2020 Census PL 94-171, table P4, by block
