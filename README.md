# ESPN Cricinfo Batting Statistics Web Scraping

This repository contains R scripts to scrape batting statistics data from ESPN Cricinfo and export the results into a CSV file.

espncricinfo-batting-web-scraping/

│
├── cricket_web_scrapping_one_page.R     # R script to scrape batting data from a single ESPN Cricinfo page
├── cricket_web_scraping_r.R             # R script to scrape and combine batting data from multiple pages
├── README.md                            # Project documentation
│
└── data/
    ├── espncricinfo_page1_batting.csv    # Output dataset generated from single-page scraper
    └── espncricinfo_all_batting.csv      # Combined dataset generated from multi-page scraper

##  Project Description

This project demonstrates:

- Web scraping using R
- Handling multiple pages of data
- Cleaning and structuring HTML tables
- Exporting structured data into CSV format

The scripts extract batting statistics from ESPN Cricinfo and compile them into a clean dataset.

---

## Tools & Libraries Used

- R
- rvest
- httr
- dplyr
- stringr

---

##  How to Run

1. Open RStudio
2. Set your working directory to the project folder:

```r
setwd("your/project/path")

3. Run single-page scraper: 
source("cricket_web_scrapping_one_page.R")

Output will be saved as:
data/espncricinfo_page1_batting.csv

4. 








