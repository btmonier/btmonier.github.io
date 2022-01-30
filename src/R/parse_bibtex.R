# library(magrittr)

source("src/R/fun_parse_bibtex.R")

headTemplate <- "assets/templates/head.html"
tailTemplate <- "assets/templates/tail.html"
bibFile      <- "assets/publications.bib"
outputFile   <- "publications.html"


rawDf <- parseBibtex()

writeLines(
    text = c(
        readLines(headTemplate),
        "<h1>Publications</h1>",
        sectionParser("unpublished"),
        sectionParser("book"),
        sectionParser("article"),
        sectionParser("thesis"),
        "<br>",
        paste0(
            "<p><i>Last Compiled: </i><code>",
            format(Sys.Date(), '%Y-%m-%d'),
            "</code></p>"
        ),
        readLines(tailTemplate)
    ),
    con = outputFile
)


