library(rvest)
library(stringr)
library(purrr)
library(dplyr)
links <- read.table('misc/genera_abstract_links.txt')[[1]]
tim <- system.time({
      abstracts <- map(links[1:10], ~ {
            html <- rvest::read_html(.x)
            genus <- rvest::html_node(html, '.citation__title') |>
                  rvest::html_text2()
            abstract <- rvest::html_node(html, '.article-section__content p:nth-child(3)' ) |>
                  rvest::html_text2()
            data.frame(
                  genus = genus,
                  abstract = abstract
            )
      }) |>
            dplyr::bind_rows() |>
            dplyr::mutate(genus = sub(' *†$', '', genus))
})
readr::write_tsv(x = abstracts, file = 'bergeys_abstracts_2023-11-09.tsv')

