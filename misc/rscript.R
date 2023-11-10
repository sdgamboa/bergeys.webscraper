library(rvest)
library(stringr)
library(purrr)
library(dplyr)
library(logr)
logfile <- "log_file"
lf <- log_open(logfile, logdir = FALSE, compact = TRUE, show_notes = FALSE)
links <- read.table('misc/genera_abstract_links.txt')[[1]]
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
                  message('Index ', n, ' failed.')
                  return(NULL)
            }
            genus <- html_node(html, '.citation__title') |>
                  html_text2()
            abstract <- html_node(html, '.article-section__content p:nth-child(3)' ) |>
                  html_text2()
            message('Got ', genus, ' - Number ', n, '.')
            n <<- n + 1
            data.frame(
                  genus = genus,
                  abstract = abstract
            )
      }) |>
            bind_rows() |>
            mutate(genus = sub(' *†$', '', genus))
}) |>
      discard(is.null) |>
      bind_rows() |>
      mutate(genus = sub(' *†$', '', genus))
log_print(tim)
write_tsv(x = abstracts, file = 'bergeys_abstracts_2023-11-09.tsv')
log_close()
