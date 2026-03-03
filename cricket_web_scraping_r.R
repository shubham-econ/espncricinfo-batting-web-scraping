# ============================================================
# ESPN Cricinfo - Test Batting Web Scraper (All Pages)
# ============================================================

# ------------------------------------------------------------
# 1. Clear Environment
# ------------------------------------------------------------

rm(list = ls())   # Remove all existing objects from memory


# ------------------------------------------------------------
# 2. Load Required Libraries
# ------------------------------------------------------------

library(httr)     # For sending HTTP requests
library(rvest)    # For scraping HTML content
library(dplyr)    # For data manipulation
library(stringr)  # For string handling


# ------------------------------------------------------------
# 3. Function: Fetch a Single Page
# ------------------------------------------------------------

fetch_page <- function(page_num) {
  
  # Construct dynamic URL for each page
  url <- paste0(
    "https://stats.espncricinfo.com/ci/engine/stats/index.html?",
    "class=1;page=", page_num, ";template=results;type=batting"
  )
  
  # Send HTTP request
  response <- GET(
    url,
    user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64)"),
    timeout(30)
  )
  
  # Stop if request fails
  if (status_code(response) != 200) {
    return(NULL)
  }
  
  # Parse HTML content
  read_html(content(response, "text", encoding = "UTF-8"))
}


# ------------------------------------------------------------
# 4. Function: Detect Total Number of Pages
# ------------------------------------------------------------

get_total_pages <- function() {
  
  # Fetch first page
  page <- fetch_page(1)
  if (is.null(page)) return(NA)
  
  # Extract page text containing pagination info
  page_text <- page %>%
    html_nodes("div.engineTable") %>%
    html_text() %>%
    paste(collapse = " ")
  
  # Extract total page number using regex
  str_extract(page_text, "(?<=Page 1 of )\\d+") %>%
    as.integer()
}


# ------------------------------------------------------------
# 5. Function: Keep Only Batting Innings Links
# ------------------------------------------------------------

keep_batting_innings <- function(nodes) {
  
  # Extract visible text from links
  texts <- html_text(nodes, trim = TRUE)
  
  # Keep only links with exact text
  nodes[texts == "View batting innings for player"]
}


# ------------------------------------------------------------
# 6. Function: Scrape One Page
# ------------------------------------------------------------

scrape_page <- function(page_num) {
  
  # Fetch page
  page <- fetch_page(page_num)
  if (is.null(page)) return(NULL)
  
  # Extract all tables from page
  tables <- page %>% html_table(fill = TRUE)
  
  # Identify table containing "Player" column
  stats_idx <- which(sapply(tables, function(t)
    "Player" %in% names(t)))
  
  if (length(stats_idx) == 0) return(NULL)
  
  # Extract correct table
  stats_table <- tables[[stats_idx[1]]]
  
  # Keep first 11 columns only
  stats_table <- stats_table[, 1:min(11, ncol(stats_table))]
  
  # Remove repeated header rows
  stats_table <- stats_table %>%
    filter(Player != "Player", Player != "")
  
  # Extract all anchor tags
  batting_links <- page %>%
    html_nodes("a") %>%
    keep_batting_innings()
  
  # Extract href attribute
  innings_urls <- batting_links %>%
    html_attr("href") %>%
    str_trim()
  
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
  
  # Polite delay to avoid server blocking
  Sys.sleep(runif(1, 1.5, 3))
  
  stats_table
}


# ------------------------------------------------------------
# 7. Main Execution
# ------------------------------------------------------------

# Detect total pages
total_pages <- get_total_pages()

# Fallback if detection fails
if (is.na(total_pages) || total_pages == 0) {
  total_pages <- 30
}

# Scrape all pages
all_data <- lapply(1:total_pages, scrape_page)

# Remove NULL results
all_data <- Filter(Negate(is.null), all_data)

# Combine all pages into one dataframe
final_df <- bind_rows(all_data)


# ------------------------------------------------------------
# 8. Save Output
# ------------------------------------------------------------

write.csv(
  final_df,
  "espncricinfo_all_batting.csv",
  row.names = FALSE
)

