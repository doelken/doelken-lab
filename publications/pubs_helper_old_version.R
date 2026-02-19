# ```{r other_Working_version}
# #| eval: false
# #| echo: false
# # ---
# # title: "Publications"
# # page-layout: full
# # bibliography: "publications/Website.bib"
# # ---
# #
# # #{r sections_ref_generator}
# # #| echo: false
# # #| results: asis
# # #| message: false
# # #| warning: false
# #
# # library(RefManageR)
# # library(dplyr)
# #
# #
# # # 1. Initialize the style environment
# # BibOptions(
# #   check.entries = FALSE,
# #   style = "markdown",
# #   bib.style = "numeric",
# #   sorting = "ydnt",
# #   max.names = 100,
# #   first.inits = FALSE # <--- THIS FIXES THE FIRST AUTHOR ORDER
# # )
# #
# #
# #
# # # 2. Load the file
# # bib <- ReadBib("publications/Website.bib")
# #
# # # 3. Targeted cleanup (Removes "visited on" without breaking the keys)
# # for (i in seq_along(bib)) {
# #     bib[[i]]$urldate <- NULL
# # }
# #
# # # 4. Extract years for the loop
# # df <- as.data.frame(bib)
# # df$year <- as.numeric(as.character(df$year))
# # years <- sort(unique(df$year[!is.na(df$year)]), decreasing = TRUE)
# #
# # # 5. The Print Loop
# # for (yy in years) {
# #   cat("\n## ", yy, "\n\n", sep = "")
# #   year_bib <- bib[year = as.character(yy)]
# #   NoCite(year_bib)
# #   PrintBibliography(year_bib)
# # }
# ```