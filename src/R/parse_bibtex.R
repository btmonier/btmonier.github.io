# library(magrittr)

source("src/R/fun_parse_bibtex.R")
source("src/R/scrape_scholar.R")

headTemplate <- "assets/templates/head.html"
tailTemplate <- "assets/templates/tail.html"
bibFile      <- "assets/publications.bib"
outputFile   <- "publications.html"
statsImg     <- "images/stats/scholar_stats.png"


rawDf <- parseBibtex()

writeLines(
    text = c(
        readLines(headTemplate),
        "<h1>Publications</h1>",
        sectionParser("unpublished"),
        sectionParser("book"),
        sectionParser("article"),
        sectionParser("thesis"),
        paste0(
            "<h2>Stats</h2>",
            "<p><img src=\"",
            statsImg,
            "\" alt=\"Google Scholar Stats\"></p>",
            "\n"
        ),
        metrics %>% unlist(),
        paste0(
            "<br>",
            "<p><i>Last Compiled: </i><code>",
            format(Sys.Date(), '%Y-%m-%d'),
            "</code></p>",
            "\n"
        ),
        readLines(tailTemplate)
    ),
    con = outputFile
)


