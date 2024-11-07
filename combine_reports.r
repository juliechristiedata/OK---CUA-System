# Libraries
library(data.table)
library(tidyverse)

# Import all reports and then combine them into one file
all_reports <-
  list.files(path = "act_33_quarterly/csv files/",
             pattern = "\\.csv$",
             full.names = TRUE) %>%
  map_df(~read_csv(., col_types = cols(.default = "c")))

# Remove rows where there are no county
all_reports <- all_reports %>%
  filter(!is.na(county))

# Clean up the name referencing the county
all_reports$county <- word(all_reports$county, 1)

# Identify the county totals
county_totals <- all_reports %>%
  group_by(county) %>%
  summarise(total = n()) %>%
  arrange(total)

view(county_totals)

# Spot clean incorrect values
allegheny_fix <- c(1261, 869, 870)

all_reports[allegheny_fix, 2] <- "Allegheny"

cambria_fix <- c(722, 873, 874, 966)

all_reports[cambria_fix, 2] <- "Cambria"

all_reports[562, 2] <- "Delaware"

all_reports[1250, 2] <- "Monroe"

all_reports[1195, 2] <- "Wayne"

# Use Regex to find out the incident date and whether the family was known

# Define a function to extract the first date from a string
extract_incident_date <- function(narrative) {
  # Regular expression to match dates in the format Month/Mon. DD, YYYY
  date_pattern <- "\\b(?:Jan\\.|Feb\\.|Mar\\.|Apr\\.|May|Jun\\.|Jul\\.|Aug\\.|Sep\\.|Sept\\.|Oct\\.|Nov\\.|Dec\\.)\\s\\d{1,2},\\s\\d{4}\\b|\\b(?:January|February|March|April|May|June|July|August|September|October|November|December)\\s\\d{1,2},\\s\\d{4}\\b"
  
  # Use str_extract to get the first match
  incident_date <- str_extract(narrative, date_pattern)
  
  return(incident_date)
}

# Apply the function to the 'text' column and create a new column 'first_date'
all_reports$incident_date <- sapply(all_reports$narrative, extract_incident_date)

# Define a function to pull the first sentence that has "known" or "prior" in it
extract_prior_status <- function(narrative) {
  # Regular expression to match the words
  prior_pattern <- "[^.]* (?:(?:was known|was not known)|(?:had prior|had no prior)|history|involved) [^.]*\\."

  #Use str_extract to get the first match
  prior_status <- str_extract(narrative, prior_pattern)

  return(prior_status)
}

# Apply function to 'narrative' column and create a new column 'prior_status'
all_reports$prior_status <- sapply(all_reports$narrative, extract_prior_status)

view(all_reports)

# Understand how many rows did not have successful pulls of known status
sum(is.na(all_reports))

# NEW ALL REPORTS
all_reports2 <- read.csv("/Users/juliechristie/Desktop/OK — CUA System/data/all_reports2.csv")

# Define new status function (statusfunction2), this time focusing on the phrase "the family was (not) previously known/unknown"
extract_prior_status_two <- function(narrative) {
  # Regular expression to match the words
  prior_pattern_two <- "[^.]*(?:(?:family ?was ?previously|family ?was ?not ?previously)) [^.]*\\."

  #Use str_extract to get the first match
  prior_status <- str_extract(narrative, prior_pattern_two)

  return(prior_status)
}

all_reports2$prior_status <- sapply(all_reports2$narrative, extract_prior_status_two)

view(all_reports2)

# Understand how many rows did not have successful pulls of known status
sum(is.na(all_reports2))

# Export the reports for editing
write.csv(all_reports2, "data/all_reports2.csv")

# Re-import all_reports2 after manually updating clean status based on prior status
all_reports2 <- read.csv("/Users/juliechristie/Desktop/OK — CUA System/data/all_reports2.csv")

# NEXT ROUND OF STATUS EXTRACTION
# Filter all_reports2 to pull out the empty prior status records
all_reports3 <- filter(all_reports2, is.na(prior_status))

# Define new status function (statusfunction2), this time focusing on the phrase "known to"
extract_prior_status_three <- function(narrative) {
  # Regular expression to match the words
  prior_pattern_three <- "[^.]*(?:known ?to) [^.]*\\."

  #Use str_extract to get the first match
  prior_status <- str_extract(narrative, prior_pattern_three)

  return(prior_status)
}

all_reports3$prior_status <- sapply(all_reports3$narrative, extract_prior_status_three)

view(all_reports3)

# Understand how many rows did not have successful pulls of known status
sum(is.na(all_reports3))

# Export the reports for editing
write.csv(all_reports3, "data/all_reports3.csv")

# Re-import allreports3 after manually updating clean status based on prior status
all_reports3 <- read.csv("/Users/juliechristie/Desktop/OK — CUA System/data/all_reports3.csv")

# NEXT ROUND OF STATUS EXTRACTION
# Filter all_reports3 to pull out the empty prior status records
all_reports4 <- filter(all_reports3, is.na(prior_status))

# Define new status function (statusfunction2), this time focusing on the phrase "involvement"
extract_prior_status_4 <- function(narrative) {
  # Regular expression to match the words
  prior_pattern_4 <- "[^.]*(?:involvement ?with) ?[^.]*\\."

  #Use str_extract to get the first match
  prior_status <- str_extract(narrative, prior_pattern_4)

  return(prior_status)
}

all_reports4$prior_status <- sapply(all_reports4$narrative, extract_prior_status_4)

view(all_reports4)

# Understand how many rows did not have successful pulls of known status
sum(is.na(all_reports4))

# Export the reports for editing
write.csv(all_reports4, "data/all_reports4.csv")

# Re-import all_reports4 after manually updating clean status based on prior status
all_reports4 <- read.csv("/Users/juliechristie/Desktop/OK — CUA System/data/all_reports4.csv")

# NEXT ROUND OF STATUS EXTRACTION
# Filter all_reports4 to pull out the empty prior status records
all_reports5 <- filter(all_reports4, is.na(prior_status))

# Define new status function (statusfunction2), this time focusing on the original search, but with variable spaces and adding "involvement"
extract_prior_status_5 <- function(narrative) {
  # Regular expression to match the words
  prior_pattern_5 <- "[^.]* (?:(?:was ?known|was ?not ?known)|(?:had ?prior|had ?no ?prior)|history|involved|involvement) ?[^.]*\\."

  #Use str_extract to get the first match
  prior_status <- str_extract(narrative, prior_pattern_5)

  return(prior_status)
}

all_reports5$prior_status <- sapply(all_reports5$narrative, extract_prior_status_5)

view(all_reports5)

# Understand how many rows did not have successful pulls of known status
sum(is.na(all_reports5))

# Export the reports for editing
write.csv(all_reports5, "data/all_reports5.csv")

# Re-import all_reports5 after manually updating clean status based on prior status
all_reports5 <- read.csv("/Users/juliechristie/Desktop/OK — CUA System/data/all_reports5.csv")

# MANUAL EDIT OF REMAINING RECORDS
all_reports6 <- filter(all_reports5, is.na(prior_status))

write.csv(all_reports6, "data/all_reports6.csv")

# Re-import all_reports6 after manually updating clean status baed on narrative and adding supporting sentence.
all_reports6 <- read.csv("/Users/juliechristie/Desktop/OK — CUA System/data/all_reports6.csv")

# MERGE ALL REPORT FILES TOGETHER

# One-time import of all reports after some manual updating
all_reports1 <- read.csv("/Users/juliechristie/Desktop/OK — CUA System/data/all_reports.csv")

# Remove records that did not have a value already, or were marked U
all_reports1 <- all_reports1 %>% 
  filter(!clean_prior_status %in% c("U", ""))

# In reports 2-5, remove the records with "NA" prior statuses
all_reports2 <- filter(all_reports2, !is.na(prior_status))
all_reports3 <- filter(all_reports3, !is.na(prior_status))
all_reports4 <- filter(all_reports4, !is.na(prior_status))
all_reports5 <- filter(all_reports5, !is.na(prior_status))

# In reports 2-6, remove row number ID columns that are not necessary
all_reports2 <- select(all_reports2, X, status, county, incident_date, clean_prior_status, prior_status, narrative)
all_reports3 <- select(all_reports3, X, status, county, incident_date, clean_prior_status, prior_status, narrative)
all_reports4 <- select(all_reports4, X, status, county, incident_date, clean_prior_status, prior_status, narrative)
all_reports5 <- select(all_reports5, X, status, county, incident_date, clean_prior_status, prior_status, narrative)
all_reports6 <- select(all_reports6, X, status, county, incident_date, clean_prior_status, prior_status, narrative)

# Bind all the dataframes together into all_reports
all_reports <- bind_rows(all_reports1, all_reports2, all_reports3, all_reports4, all_reports5, all_reports6)

# Spot clean for date formats
all_reports$incident_date <- gsub("January", "Jan.", all_reports$incident_date)

all_reports$incident_date <- gsub("February", "Feb.", all_reports$incident_date)

all_reports$incident_date <- gsub("March", "Mar.", all_reports$incident_date)

all_reports$incident_date <- gsub("April", "Apr.", all_reports$incident_date)

all_reports$incident_date <- gsub("June", "Jun.", all_reports$incident_date)

all_reports$incident_date <- gsub("July", "Jul.", all_reports$incident_date)

all_reports$incident_date <- gsub("August", "Aug.", all_reports$incident_date)

all_reports$incident_date <- gsub("September", "Sep.", all_reports$incident_date)

all_reports$incident_date <- gsub("October", "Oct.", all_reports$incident_date)

all_reports$incident_date <- gsub("November", "Nov.", all_reports$incident_date)

all_reports$incident_date <- gsub("December", "Dec.", all_reports$incident_date)

# Fix leading 0s
all_reports$incident_date <- gsub(" 0", " ", all_reports$incident_date)

# Fix bad Feb. dates
all_reports$incident_date <- gsub("Feb. 30", "Feb. 1", all_reports$incident_date)

# Remove periods
all_reports$incident_date <- gsub("\\.", "", all_reports$incident_date)

# Format incident_date as datetime
all_reports$incident_date <- parse_date_time(all_reports$incident_date, orders = c("mdy", "dmy"))

# Get year and quarter for all cases
all_reports <- all_reports %>%
  mutate(year = year(incident_date),
         quarter = quarter(incident_date,
            type = "date_first",
            fiscal_start = 1))


# Rearrange the table to be more readable
all_reports <- all_reports %>%
  select(X, status, county, incident_date, year, quarter, clean_prior_status, prior_status, narrative)

# Filter for Philadelphia reports
phl_reports <- all_reports %>%
  filter(county == "Philadelphia") %>%
  mutate(year = year(incident_date))
  # mutate(year = substr(incident_date, nchar(incident_date) - 3, nchar(incident_date)))

sum(is.na(phl_reports))

# Graph the timeline of annual PHL cases

phl_timeline <- phl_reports %>%
  group_by(year) %>%
  summarise(cases = n())

ggplot(data = phl_timeline,
       aes(x = year, y = cases, group = 1)) +
  geom_line(linewidth = 1.5, alpha = .75) +
  #Labels
  labs(
    y = "Number of cases",
    x = "Year",
    title = "Philadelphia fatality and near fatalities")

# Graph annual PHL cases by fatality status

phl_timeline2 <- phl_reports %>%
  group_by(year, status) %>%
  summarise(cases = n())

ggplot(data = phl_timeline2,
       aes(x = year, y = cases, group = status, color = status)) +
  geom_line(linewidth = 1.5, alpha = .75) +
  #Labels
  labs(
    y = "Number of cases",
    x = "Year",
    title = "Philadelphia fatality and near fatalities")

# Graph quarterly PHL cases in total
phl_timeline_q <- phl_reports %>%
  group_by(quarter) %>%
  summarise(cases = n())

ggplot(data = phl_timeline,
       aes(x = quarter, y = cases, group = 1)) +
  geom_line(linewidth = 1.5, alpha = .75) +
  #Labels
  labs(
    y = "Number of cases",
    x = "Quarter",
    title = "Philadelphia fatality and near fatalities")

# Write .csv files of data
write.csv(all_reports, "data/all_reports.csv")
write.csv(county_totals, "data/county_totals.csv")
write.csv(phl_reports, "data/phl_reports.csv")
write.csv(phl_timeline, "data/phl_timeline_overall.csv")
write.csv(phl_timeline2, "data/phl_timeline_type.csv")