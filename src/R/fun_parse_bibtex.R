# Functions for parsing BibTex file ---------------------------------


`%>%` <- magrittr::`%>%`

fieldCollector <- function(field, rawText) {
    ifelse(
        test = length(rawText[grep(field, rawText)]) == 0,
        yes  = return(NA),
        no   = return(rawText[grep(field, rawText)])
    )
}

parseBibtex <- function(citationUrl = bibFile) {
    ## Get raw text ----
    rawBibtex <- readLines(
        con = citationUrl
    )

    ## Split into chunks ----
    articles <- list()
    count <- 1
    j <- 0
    for (i in rawBibtex) {
        if (grepl("^@", i)) {
            k <- 2
            j <- j + 1
            articles[[j]] <- i
        } else {
            articles[[j]][k] <- i
            k <- k + 1
        }
    }

    ## Convert to data frame ----
    articleDf <- data.frame(
        title   = "",
        year    = "",
        journal = "",
        authors = "",
        type    = "",
        doi     = ""
    )
    j <- 1
    for (i in articles) {
        articleDf[j, ]$title   <- fieldCollector("title=", i)
        articleDf[j, ]$year    <- fieldCollector("year=", i)
        articleDf[j, ]$journal <- fieldCollector("journal=", i)
        articleDf[j, ]$authors <- fieldCollector("author=", i)
        articleDf[j, ]$type    <- fieldCollector("@", i)
        articleDf[j, ]$doi     <- fieldCollector("doi=", i)
        j <- j + 1
    }

    ## Clean up ----
    articleDf$title   <- gsub("title=\\{|\\}(,|$)",   "", articleDf$title) %>% trimws()
    articleDf$year    <- gsub("year=\\{|\\}(,|$)",    "", articleDf$year) %>%
        trimws() %>%
        as.numeric() %>%
        suppressWarnings() # suppress "20xx" entries for in-prep data
    articleDf$journal <- gsub("journal=\\{|\\}(,|$)", "", articleDf$journal) %>% trimws()
    articleDf$authors <- gsub("author=\\{|\\}(,|$)",  "", articleDf$author) %>%
        trimws() %>%
        gsub(" and ", "; ", .) %>%
        gsub("\\{\\\\\"a\\}", "a", .) %>%
        gsub("\\{\\\\\"o\\}", "o", .) %>%
        gsub("\\{\\\\\"u\\}", "u", .)
    articleDf$type    <- gsub("@|\\{.*", "", articleDf$type)
    articleDf$doi     <- gsub("doi=\\{|\\}(,|$)",   "", articleDf$doi) %>% trimws()

    articleDf <- articleDf[!is.na(articleDf$year), ]
    articleDf <- articleDf[order(-articleDf$year), ]
    row.names(articleDf) <- NULL

    ## HTML ----
    articleDf$authors <- gsub("Monier, Brandon", "<b>Monier, Brandon</b>", articleDf$authors)
    articleDf$journal <- ifelse(
        test = is.na(articleDf$journal),
        yes = NA,
        no = paste0("<i>", articleDf$journal, "</i>")
    )
    articleDf$journal[articleDf$type == "unpublished"] <- "<i>In preparation</i>"

    return(articleDf)
}


synDf <- c(
    "article"     = "Journal Articles",
    "book"        = "Proceedings and Book Chapters",
    "unpublished" = "In preparation",
    "thesis"      = "Theses"
)


sectionParser <- function(
    sub     = "article",
    synonym = synDf,
    rawData = rawDf
) {
    tmpHtml <- paste0("<h2>", synonym[[sub]], "</h2>")


    if (sub == "thesis") {
        tmpDf <- rawData[rawData$type == "phdthesis" | rawData$type == "mastersthesis", ]
    } else {
        tmpDf <- rawData[rawData$type == sub, ]
    }

    tmpDf %<>%
        split(., f = .$year) %>%
        rev()

    tmpLs <- vector("list", tmpDf %>% length())
    for (i in tmpDf %>% length() %>% seq_len()) {
        for (j in tmpDf[[i]] %>% nrow() %>% seq_len()) {
            tmpLs[[i]][1] <- paste0("<h3>", names(tmpDf)[i], "</h3>")
            tmpLs[[i]][j + 1] <- paste0(
                "<p>",
                tmpDf[[i]][j, ]$authors,
                " (", tmpDf[[i]][j, ]$year, ") ",
                tmpDf[[i]][j, ]$title, ". ",
                tmpDf[[i]][j, ]$journal,
                " doi: <a class=\"body\" href=\"", tmpDf[[i]][j, ]$doi, "\">", tmpDf[[i]][j, ]$doi, "</a>",
                "</p>"
            )
        }
    }

    return(c(tmpHtml, tmpLs %>% unlist()))
}


