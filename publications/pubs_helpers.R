library(RefManageR)
library(stringr)

# ---- Config ----
lab_names <- c(
  "Lars Dölken",
  "Thomas Hennig",
  "Patrick Fischer",
  "Adam W. Whisnant",
  "Arnhild Grothey",
  "Marco Olguin-Nava",
  "Claire Rousseau"
)

# ----- Exclude publications with Gottfried Dölken ----- #

exclude_author <- "Gottfried Dölken"

has_excluded_author <- function(e) {
  a <- author_string(e)
  if (!is.character(a) || length(a) != 1) return(FALSE)
  stringr::str_detect(a, stringr::fixed("Gottfried")) &&
    stringr::str_detect(a, stringr::fixed("Dölken"))
}

# ---- Data load ----
read_bib <- function(path = "publications/Website.bib") {
  ReadBib(path)
}

# ---- Helpers ----
highlight_authors <- function(auth, names = lab_names) {
  if (!is.character(auth) || length(auth) != 1 || !nzchar(auth)) return(auth)
  
  for (nm in names) {
    auth <- stringr::str_replace_all(
      auth,
      stringr::fixed(nm),
      paste0("<span class='lab-author'>", nm, "</span>")
    )
  }
  auth
}

best_link <- function(e) {
  if (!is.null(e$doi) && nzchar(e$doi)) {
    doi <- as.character(e$doi)
    doi <- sub("^https?://(dx\\.)?doi\\.org/", "", doi)
    return(paste0("https://doi.org/", doi))
  }
  if (!is.null(e$url) && nzchar(e$url)) return(as.character(e$url))
  
  if (!is.null(e$eprint) && nzchar(e$eprint) &&
      !is.null(e$archiveprefix) &&
      tolower(as.character(e$archiveprefix)) == "arxiv") {
    return(paste0("https://arxiv.org/abs/", as.character(e$eprint)))
  }
  NULL
}

get_year <- function(e) {
  if (!is.null(e$year) && nzchar(as.character(e$year))) {
    return(as.integer(e$year))
  }
  if (!is.null(e$date) && nzchar(as.character(e$date))) {
    return(as.integer(substr(as.character(e$date), 1, 4)))
  }
  NA_integer_
}

get_venue <- function(e) {
  for (f in c("journaltitle", "journal", "booktitle", "publisher")) {
    if (!is.null(e[[f]]) && nzchar(as.character(e[[f]]))) {
      return(as.character(e[[f]]))
    }
  }
  if (!is.null(e$howpublished) && nzchar(as.character(e$howpublished))) {
    return(as.character(e$howpublished))
  }
  ""
}

author_string <- function(e) {
  a <- e$author
  if (is.null(a)) return("")
  
  out <- as.character(a)
  if (length(out) > 1) out <- paste(out, collapse = ", ")
  gsub("\\s+and\\s+", ", ", out)
}

clean_title <- function(t) {
  if (is.null(t)) return("")
  t <- as.character(t)
  t <- gsub("[{}]", "", t)
  t <- gsub("\\s+", " ", t)
  trimws(t)
}

get_years <- function(bib) {
  sort(unique(na.omit(vapply(bib, get_year, integer(1)))), decreasing = TRUE)
}

check_bib <- function(bib) {
  keys <- names(bib)
  
  years <- vapply(bib, get_year, integer(1))
  missing_year <- keys[is.na(years)]
  
  # Missing title
  missing_title <- keys[vapply(bib, function(e) is.null(e$title) || !nzchar(as.character(e$title)), logical(1))]
  
  # Link availability (DOI/URL/arXiv)
  links <- vapply(bib, function(e) !is.null(best_link(e)) && nzchar(best_link(e)), logical(1))
  missing_link <- keys[!links]
  
  list(
    missing_year = missing_year,
    missing_title = missing_title,
    missing_link = missing_link
  )
}