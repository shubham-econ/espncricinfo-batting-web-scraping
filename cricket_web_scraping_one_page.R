# ─────────────────────────────────────────────
# Clear Environment
# ─────────────────────────────────────────────
rm(list = ls())

# ─────────────────────────────────────────────
# Load Libraries
# ─────────────────────────────────────────────
library(httr)
library(rvest)
library(dplyr)
library(stringr)

# ─────────────────────────────────────────────
# Fetch Page 1
# ─────────────────────────────────────────────
url <- "https://stats.espncricinfo.com/ci/engine/stats/index.html?class=1;page=1;template=results;type=batting"

response <- GET(
  url,
  user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64)"),
  timeout(30)
)

if (status_code(response) != 200) {
  stop("Failed to access page. Status: ", status_code(response))
}


cat(content(response, "text", encoding = "UTF-8"))





#converts the website response into an HTML object that R can read and scrape.

page <- read_html(content(response, "text", encoding = "UTF-8"))

# ─────────────────────────────────────────────
# Extract Batting Table
# ─────────────────────────────────────────────
tables <- page %>% html_table(fill = TRUE)  #get multiple tables from the webpage.

# But I only want the batting statistics table
# so Find table containing 'Player' column
stats_idx <- which(sapply(tables, function(t) "Player" %in% names(t)))

if (length(stats_idx) == 0) {
  stop("Batting table not found.")
}

stats_table <- tables[[stats_idx[1]]]

# Keep first 11 columns
stats_table <- stats_table[, 1:min(11, ncol(stats_table))]

# Remove repeated header rows
stats_table <- stats_table %>%
  filter(Player != "Player", Player != "")

# ─────────────────────────────────────────────
# Extract Innings Links
# ─────────────────────────────────────────────
batting_links <- page %>%
  html_nodes("a") %>%      #This extracts all <a> tags from the webpage.
  .[html_text(., trim = TRUE) == "View batting innings for player"] # Filter Only Batting Innings Links 

# "a" = anchor tag (hyperlinks in HTML)
# html_text(.) → extracts visible text inside each <a> tag
# trim = TRUE → removes extra spaces
# == "View batting innings for player" → keeps only exact matches


innings_urls <- batting_links %>%
  html_attr("href") %>%  #From each <a> tag, extract the value inside:
  str_trim() # Removes any extra spaces around the URL

# Convert relative URLs to full URLs
innings_urls <- ifelse(
  str_starts(innings_urls, "http"),
  innings_urls,
  paste0("https://stats.espncricinfo.com", innings_urls)
)

# Match rows and URLs safely
n <- min(nrow(stats_table), length(innings_urls))

stats_table <- stats_table[1:n, ]
stats_table$InningsURL <- innings_urls[1:n]

colnames(stats_table)

dir.create("data")

write.csv(stats_table,
          "data/espncricinfo_page1_batting.csv",
          row.names = FALSE)





