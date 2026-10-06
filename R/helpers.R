# Shared data loading and map helpers for the site pages

suppressPackageStartupMessages({
  library(tidyverse)
  library(sf)
  library(leaflet)
  library(reactable)
  library(htmltools)
})
sf_use_s2(FALSE)

site_root = Sys.getenv("QUARTO_PROJECT_DIR", here::here())

deserts = st_read(file.path(site_root, "data/web/deserts.gpkg"), quiet = TRUE)
prec26 = st_read(file.path(site_root, "data/web/precincts26.gpkg"), quiet = TRUE)
prec20 = st_read(file.path(site_root, "data/web/precincts20.gpkg"), quiet = TRUE)
crosswalk = read_csv(file.path(site_root, "data/downloads/desert-precincts-2026.csv"), col_types = cols(precinct_2026 = "c", .default = col_guess()))

county_labels = c(harris = "Harris", fort_bend = "Fort Bend", montgomery = "Montgomery")

# JA palette (jastyle::ja_colors)
col_desert = "#083563"
col_core = "#058FB3"
col_partial = "#FBD753"
col_other = "#8a9aa6"

slugify = function(x) {
  x |> str_to_lower() |> str_remove_all("\\(.*?\\)") |> str_replace_all("[^a-z0-9]+", "-") |> str_remove_all("^-|-$")
}

# Carto tiles via jaspatial, keyed with CARTO_API_KEY from .Renviron. The key appears in
# the published HTML; it is restricted to JA domains (including this Pages site).
# Built by hand rather than with ja_base_map() to skip its print and OSM-search controls.
base_map = function() {
  leaflet(options = leafletOptions(minZoom = 8)) |>
    addMapPane("polygons", zIndex = 410) |>
    addMapPane("maplabels", zIndex = 420) |>
    jaspatial::add_carto_basemap(variant = "light_nolabels") |>
    jaspatial::add_carto_labels(variant = "light_only_labels", pane = "maplabels")
}

display_name = function(x) str_remove(x, " \\(.*\\)$")

fit_to = function(map, x) {
  bb = st_bbox(x)
  fitBounds(map, bb[["xmin"]], bb[["ymin"]], bb[["xmax"]], bb[["ymax"]])
}

precinct_list = function(df) {
  core = df$precinct_2026[df$status == "core"]
  partial = df$precinct_2026[df$status == "partial"]
  tags$div(
    class = "precinct-list",
    tags$span(paste(core, collapse = ", ")),
    if (length(partial)) tags$span(class = "partial", paste0(" · partial: ", paste(partial, collapse = ", ")))
  )
}
