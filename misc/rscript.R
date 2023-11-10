library(rvest)
library(stringr)
library(purrr)
library(dplyr)
library(logr)
library(readr)
logfile <- "log_file"
lf <- log_open(logfile, logdir = FALSE, compact = TRUE, show_notes = FALSE)
links <- read.table('genera_abstract_links.txt')[[1]]
msg <- paste0('Number of links: ', length(links))
log_print(msg, blank_after = TRUE)
n <- 1
tim <- system.time({
      abstracts <- map(links, ~ {
            html <- tryCatch(
                  error = function(e) return(NULL), {
                        read_html(.x)
                  }
            )
            if (!length(html)) {
                  n <<- n + 1
                  message('Index ', n, ' failed. Link: ', .x)
                  return(NULL)
            }
            genus <- html_node(html, '.citation__title') |>
                  html_text2()
            abstract <- html_node(html, '.article-section__content' ) |>
                  html_text2()
            msg <- paste0('Got ', genus, ' - Number ', n, '. Link: ', .x)
            log_print(msg)
            n <<- n + 1
            data.frame(
                  genus = genus,
                  abstract = abstract,
                  link = .x
            )
      }) |>
            bind_rows() |>
            mutate(genus = sub(' *†$', '', genus))
})
abstracts <- abstracts |>
      discard(is.null) |>
      bind_rows() |>
      mutate(genus = sub(' *†$', '', genus))
log_print(tim, blank_after = TRUE)
msg <- paste0('Number of genera recovered: ', nrow(abstracts))
log_print(msg, blank_after = TRUE)
write_tsv(x = abstracts, file = 'bergeys_abstracts_2023-11-09.tsv')
log_close()
