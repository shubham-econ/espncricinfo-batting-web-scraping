
```markdown
#  ESPN Cricinfo Batting Statistics Web Scraping

This repository contains R scripts to scrape batting statistics data from ESPN Cricinfo and export the results into structured CSV files for analysis.

---

##  Repository Structure

```

espncricinfo-batting-web-scraping/

│
├── cricket_web_scraping_one_page.R     # Scrapes batting data from a single ESPN Cricinfo page
├── cricket_web_scraping_r.R             # Scrapes and combines batting data from multiple pages
├── README.md                            # Project documentation
│
└── data/
├── espncricinfo_page1_batting.csv    # Output dataset from single-page scraper
└── espncricinfo_all_batting.csv      # Combined dataset from multi-page scraper

````

---

##  Project Description

This project demonstrates:

- Web scraping using R  
- Handling single and multiple page extraction  
- Cleaning and structuring HTML tables  
- Exporting structured datasets into CSV format  
- Organizing a reproducible project workflow  

The scripts extract batting statistics from ESPN Cricinfo and compile them into clean datasets ready for further analysis.

---

## 🛠 Tools & Libraries Used

- **R**
- `rvest` – HTML parsing  
- `httr` – HTTP requests  
- `dplyr` – Data manipulation  
- `stringr` – Text processing  

---


### 1. Open in RStudio

Set your working directory to the project folder:

```r
setwd("path/to/espncricinfo-batting-web-scraping")
```

---

### 2. Run Single-Page Scraper

```r
source("cricket_web_scraping_one_page.R")
```

Output will be saved as:

```
data/espncricinfo_page1_batting.csv
```

---

### 3. Run Multi-Page Scraper

```r
source("cricket_web_scraping_r.R")
```

Output will be saved as:

```
data/espncricinfo_all_batting.csv
```

---

## Output Dataset Includes

* Player Name
* Career Span
* Matches
* Innings
* Runs
* Batting Average
* Strike Rate
* 100s / 50s
* Highest Score

---

## Disclaimer

This project is for educational and research purposes only.
All data rights belong to ESPN Cricinfo.

---

## Author

Shubham Bhandare

```

---


