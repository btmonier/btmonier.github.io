library(magrittr)


parseBibtex <- function() {
    ## Get raw text ----
    citationUrl <- "https://scholar.googleusercontent.com/citations?view_op=export_citations&user=buYGhlYAAAAJ&citsig=AMD79ooAAAAAYd3JMXzkstAdDHwPa9r_b6fTxFwH6zBe&hl=en"
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
        authors = ""
    )
    j <- 1
    for (i in articles) {
        articleDf[j, ]$title   <- ifelse(
            test = length(i[grep("title=", i)]) == 0, 
            yes  = NA, 
            no   = i[grep("title=", i)]
        )
        articleDf[j, ]$year    <- ifelse(
            test = length(i[grep("year=", i)]) == 0, 
            yes  = NA, 
            no   = i[grep("year=", i)]
        )
        articleDf[j, ]$journal <- ifelse(
            test = length(i[grep("journal=", i)]) == 0, 
            yes  = NA, 
            no   = i[grep("journal=", i)]
        )
        articleDf[j, ]$authors <- ifelse(
            test = length(i[grep("author=", i)]) == 0, 
            yes  = NA, 
            no   = i[grep("author=", i)]
        )
        j <- j + 1
    }
    
    
    ## Clean up ----
    articleDf$title   <- gsub("title=\\{|\\},",   "", articleDf$title) %>% trimws()
    articleDf$year    <- gsub("year=\\{|\\},",    "", articleDf$year) %>% trimws() %>% as.numeric()
    articleDf$journal <- gsub("journal=\\{|\\},", "", articleDf$journal) %>% trimws()
    articleDf$authors <- gsub("author=\\{|\\},",  "", articleDf$author) %>%
        trimws() %>%
        gsub(" and ", "; ", .) %>%
        gsub("\\{\\\\\"a\\}", "ä", .) %>% 
        gsub("\\{\\\\\"o\\}", "ö", .) %>% 
        gsub("\\{\\\\\"u\\}", "ü", .)
    
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
    
    return(articleDf)
}


articleDf <- parseBibtex()



