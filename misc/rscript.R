pdfUrl <- "https://onlinelibrary.wiley.com/pb-assets/assets/9781118960608/A_Z_170327-1507044704000.pdf"
fileName <- tempfile()
download.file(url = pdfUrl, destfile = fileName)
txt <- unlist(pdftools::pdf_attachments(fileName))

library(readr)
library(purrr)
txt <- read_file_raw(fileName)

vector_txt <- map_chr(txt, rawToChar)
vector_txt[[17]]

x <- paste0(vector_txt, collapse = '')


grep('http', txt)


vector_Txt <- rep("", nb_Txt)

for(i in 1 : nb_Txt) {
      vector_Txt[i] <- rawToChar(txt[i])
}

vect


r

nb_Txt <- length(txt)
vector_Txt <- rep("", nb_Txt)

for(i in 1:nb_Txt) {
      print(i)
      vector_Txt[i] <- rawToChar(txt[i])
}

x <- readr::read_file_raw(fileName)




