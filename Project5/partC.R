library(tidyverse)
library(dplyr)
library(jsonlite)
library(magick)
library(rvest)
library(ggplot2)

keywords <- c("education", "crime", "immigration")

search1 <- read_html(paste0("https://datalandscapes.online/scrapeable/speeches.php?search=", keywords[1])) %>%
       html_elements(".speech_summary") %>%
       html_text2() %>%
       tibble(
              keyword = keywords[1],
              results = .
       ) %>%
       separate(results, into = c("year", "num_speeches"), sep = "--") %>%
       mutate(
              num_speeches = parse_number(num_speeches),
              year = parse_number(year)
       )

search2 <- read_html(paste0("https://datalandscapes.online/scrapeable/speeches.php?search=", keywords[2])) %>%
       html_elements(".speech_summary") %>%
       html_text2() %>%
       tibble(
              keyword = keywords[2],
              results = .
       ) %>%
       separate(results, into = c("year", "num_speeches"), sep = "--") %>%
       mutate(
              num_speeches = parse_number(num_speeches),
              year = parse_number(year)
       )

search3 <- read_html(paste0("https://datalandscapes.online/scrapeable/speeches.php?search=", keywords[3])) %>%
       html_elements(".speech_summary") %>%
       html_text2() %>%
       tibble(
              keyword = keywords[3],
              results = .
       ) %>%
       separate(results, into = c("year", "num_speeches"), sep = "--") %>%
       mutate(
              num_speeches = parse_number(num_speeches),
              year = parse_number(year)
       )

combined_search <- bind_rows(search1, search2, search3)
speeches_governments <- read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vRHTFJcFmsIkjaFUCEwFWASaBOAR4X2Upx66C5Bhgc_WNc2JxxdRbbvyoewmvt_EjNdCNZZzzkENwLg/pub?gid=0&single=true&output=csv")
view(speeches_governments)
view(combined_search)

speech_data <- inner_join(combined_search, speeches_governments, by = "year")
#view(speech_data)

# Create the plot
ggplot(speech_data, aes(x = year, y = num_speeches, color = keyword)) +
  geom_line() +
  labs(title = "Number of speeches made each year, compared by keyword",
       x = "Year",
       y = "Number of speeches",
       color = "Keyword") +
  theme_minimal()
