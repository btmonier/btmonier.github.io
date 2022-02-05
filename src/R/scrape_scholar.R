library(ggplot2)


## Parameters ----
url     <- "https://scholar.google.com/citations?user=buYGhlYAAAAJ&hl=en"
pltPath <- "images/stats/scholar_stats.png"


## Scrape HTML ----
gsHtml <- url %>% rvest::read_html()
yearV  <- gsHtml %>%
    rvest::html_nodes(".gsc_g_t") %>%
    rvest::html_text()
citV   <- gsHtml %>%
    rvest::html_nodes(".gsc_g_a") %>%
    rvest::html_text() %>%
    as.numeric()


## Yearly data ----
yearlyStats <- data.frame(
    year      = yearV,
    citations = citV
)

if (yearlyStats %>% nrow() > 5) {
    indexes <- yearlyStats %>% nrow() %>% seq_len() %>% tail(5)
    yearlyStats <- yearlyStats[indexes, ]
}


## Citation metrics ----
citationDf <- gsHtml %>%
    rvest::html_nodes("#gsc_rsb_st") %>%
    rvest::html_table() %>%
    .[[1]] %>%
    as.data.frame()

metrics <- list()
metrics[[1]] <- c(
    "<table>",
    "<tr>",
    paste0("<th>", "Metric", "</th>"),
    paste0("<th>", colnames(citationDf)[2], "</th>"),
    paste0("<th>", colnames(citationDf)[3], "</th>"),
    "</tr>"
)
for (i in citationDf %>% nrow() %>% seq_len()) {
    metrics[[i + 1]] <- c(
        "<tr>",
        paste0("<td>", citationDf[i, 1], "</td>"),
        paste0("<td>", citationDf[i, 2], "</td>"),
        paste0("<td>", citationDf[i, 3], "</td>"),
        "</tr>"
    )
}
metrics[[metrics %>% length() + 1]] <- "</table>"


## Visualize and export ----
plt <- yearlyStats %>%
    ggplot() +
    aes(x = year, y = citations) +
    geom_bar(
        stat  = "identity",
        fill  = "#c7c9f0",
        color = "#575757",
        width = 0.5
    ) +
    ylab("# citations") +
    theme_minimal() +
    theme(axis.title.x = element_blank())

ggsave(
    filename = pltPath,
    plot     = plt,
    device   = "png",
    units    = "px",
    width    = 290,
    height   = 250,
    dpi      = 100,
    bg       = "white"
)


