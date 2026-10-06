# Writes one stub page per desert into deserts/. Run before `quarto render`
# whenever the desert list changes. Each stub pulls in _desert-body.qmd.

source(file.path(here::here(), "R/helpers.R"))

unlink(list.files(file.path(site_root, "deserts"), pattern = "\\.qmd$", full.names = TRUE))

deserts |>
  st_drop_geometry() |>
  distinct(desert, county) |>
  pwalk(\(desert, county, ...) {
    stub = c(
      "---",
      paste0('title: "', str_remove(desert, " \\(.*\\)$"), '"'),
      paste0('subtitle: "', county_labels[[county]], ' County"'),
      "params:",
      paste0('  desert: "', desert, '"'),
      "---",
      "",
      "{{< include ../_desert-body.qmd >}}"
    )
    writeLines(stub, file.path(site_root, "deserts", paste0(slugify(desert), ".qmd")))
  })
