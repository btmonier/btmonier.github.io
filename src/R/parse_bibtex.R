# library(magrittr)

source("src/R/fun_parse_bibtex.R")
source("src/R/scrape_scholar.R")

headTemplate <- "assets/templates/head.html"
tailTemplate <- "assets/templates/tail.html"
bibFile      <- "https://raw.githubusercontent.com/btmonier/curriculum_vitae/master/bib/publications.bib"
outputFile   <- "publications.html"
statsImg     <- "images/stats/scholar_stats.png"


rawDf <- parseBibtex(bibFile)

writeLines(
    text = c(
        readLines(headTemplate),
        "<h1>Publications</h1>",
        if (any(rawDf$type == "unpublished")) {
            sectionParser("unpublished", synonym = synDf, rawData = rawDf)
        },
        sectionParser("book", synonym = synDf, rawData = rawDf),
        sectionParser("article", synonym = synDf, rawData = rawDf),
        sectionParser("thesis", synonym = synDf, rawData = rawDf),
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


