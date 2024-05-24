# Our Kids - CUA System Series Data Diary

**Reporter:** Julie Christie, Director of Data & Impact

[Link to methodology]()


## 2024

### May

#### 24 May, 2024

**Work Completed**

*Debugging*

- debugged vscode automatically going into the env when opening program/dropping files into explorer. this was making it impossible to deactivate the env. [followed this solution](https://stackoverflow.com/questions/54802148/prevent-visual-studio-code-from-activating-the-python-virtual-environment).
- settings file shows incorrect python path: `"python.pythonPath": "/anaconda3/bin/python",` and has the error "Unknown Configuration Setting"
  - this setting is deprecated and therefore has no impact, whether it is correct or not.
- Em helped debug the issue with psutil
  - because each line of code (even outside of the kernel) was triggering the error, it meant that it was an issue with the kernel
  - having the environment called "cua_env" was likely triggering reserved keywords and making python be stinky. `_env` is a shorthand that a lot of code looks for as an environmental variable
  - created a new environment with a better, less triggering name and set it
  - installed packages needed (pdfplumber, pandas)
  - exed out of the popup asking if i wanted to install globablly or virtually
  - restarted kernel
  - froze requirements
  - Installs ran properly

*Writing Code*

- depending on when the report was made, the first page was structured differently. 
- Cannot decide if it's better to parse 2 pieces of data from 2,400 documents or thousands from 52 documents

#### 23 May, 2024

**Work Completed**

- began drafting methodology in python markdown page, as well as documenting the cleaning process for the scraped data
- python is _very_ tempermental when working from an external drive, so copied over to desktop. decided to swith from jupyter notebooks to VSC
> :star: **Professional Development**
> Learned a Python best-practice from Kai to create a `requirements.txt` document that will make it possible for others to use and replicate the code.
- troubleshot issues running code with Kai, realized that running Python through Anaconda was causing a lot of problems and so deleted it from the computer
- the version of pdfplumber and pdfminer were also causing problems, so backtracked to versions that Kai uses and those work when in `requirements.txt` as follows:
  - `pdfminer.six==20221105`
  - `pdfplumber==0.10.3`
- left off having issues with psutil package


#### 21-22 May, 2024

**Work Completed**

- Deesarine continued to work on combining the DHS contract data; the data was very dirty and required further processing to match column numbers, names, and types before appending the data.

#### 20 May, 2024

**Work Completed**

- Figure out the research questions with the repeat abuse data from the state and federal reports
  - What is the proportion of lawsuits against a CUA compared to the number of kids they are responsible for?
  - What impact did the CUA system have on rates of child abuse?
    - How many kids were in the system each year from 2000 to 2024 (Baseline number)
    - How many kids report experiencing abuse in foster care from 2000 to 2024
      - State data: regional level, not necessarily at the county level
      - Federal data: at the state level maybe
      - Alumni reports: unsure where they are or how geographically specific they get
      - What is the difference in reports to substantiations pre/post CUA
    - How many kids died/nearly died from abuse
      - Act 33 reports: at the county level
- Found two new CUAs to check for lawsuits
  - Greater Philadelphia Community Alliance
  - Concilio
- Deesarine started pulling data together on DHS contracts with CUAs, we're going to use this to find out how much money they got
  - no data past Q4-2020 so Deesarine emailed to get it

**To Do Next**

- Figure out how the fuck to compare the abuse rate data
  - if the federal and state data don't aggregate to the same geography, how can we compare?
  - what sections of the reports can we use to compare?
- go back and recategorize negligence to be more specific

#### 16 May, 2024

**Work Completed**

_Lawsuit Database_

- combined PACER and CUA suits into one table
- Went through and filled in missing information on columns/reducing as many empty/unknown fields as possible; Airtable dashboard now reflects full numbers

#### 10 May, 2024

**Work Completed**

- Deesarine finished findng, downloading, and adding all the CUAs from PACER into the lawsuit database
- Steve sent state data on abuse within the foster care system

#### 8 May, 2024

**Work Completed**

_Abuse Rates_

- `Age` column cleaning (cont'd)
  - Aggregated all ages to a year. Everything within 0 days to 12 months was considered `<1` and then 12+ months to 24 months was considered `1`. Removed "year" after age, since all are now in units of year
- `Fatality` cleaning
  - 2 records blank, marked `NULL`
- `year` column cleaning
  - 3 recods were blank, marked `NULL`
- `date` column cleaning
  - 2 records have impossible dates (31/19) and (0/18); marked `NULL`
  - 764 have missing date but list further info is possible, leaving blank
  - 4 have missing date but do not list further info is possible, marking `NULL`
- `DA_Cert` column cleaning
  - 1 record misspelled "lifted" fixed manually
  - 79 records moved over by one column, manually fixed (DA Certification << marked `yes`, Decertified)
  - 8 recrods have conflicting info on whether they are decertified. "Decertified" appeared in the `report_url` column but the `DA_Cert` column had other vlaues. created a hybrid value for those records, removing certification information from the report column
- `report_url` column cleaning
  - Renamed to `report_title`
  - 488 records are blank << marked `NULL`
  - 438 records have `No report`
- `date` cleaning with report title
  - number strings in `report_title` are the date of the incident; spot check of records with date show they match (MM/DD/YY)
  - used this info to manually fix `null` date records (all but 2 that are clearly marked no report)
  - created `report_title_copy` to remove extra numbers and fix all dates
    - copy and paste `report_title` values
  - created `extracted_date` column to pull numbers and convert into dates
    - formula: `=TEXTJOIN("",TRUE,IFERROR(MID([@[report_title_copy]],ROW(INDIRECT("1:"&LEN([@[report_title_copy]]))),1)*1,""))`
  - created `length_check` to see any incorrect date extractions; 43 records wrong
    - formula: `=IF(LEN([@[extracted_date]])>6, "NO", "Date")`
    - filter for all "NO" values
    - manually edit `report_title_copy` values to fix dates, using find and replace
  - created `date_num` to just get the numbers, no formula for conversion to real date
    - copy `extracted_date` and paste values only
  - created `date-real` to parse numbers into dates
    - formula: `=DATE(20&RIGHT([@[date_num]],2), LEFT([@[date_num]],2), MID([@[date_num]],3,2))`
  - created `date-true` to create a non-formula reliant copy of the dates
    - copy `date-real` and paste values only
    - filter for #VALUE and delete to make blank cells
  - deleted columns `date_extract`, `length_check`, `name-copy`, `datenum`, `date-real`
  - manually fixed one record that had the year as 2080
  - filter for all filled dates in `date-true` and copied into `date` using lightning fill (2,377 records)
  - delete `date-true`
- `date` cleaning for incorrect 2024 dates
  - many dates defaulted to 2024 but the corresponding year is clearly different
  - filter for records where the `date` says 2024 but the `year` does not (835 records)
  - create new column `fix-date` and use the previous formula to parse what the correct date should be
    - formula: `=DATE([@year], TEXT([@date],"MM"), TEXT([@date],"DD"))`
  - create new column `fix-date-real` and copy and pase the value only of `fix-date`
  - clear incorrect dates and fill with lightning fill
  - delete `fix-date` and `fix-date-real`
-

_preliminary analysis_
- created pivot table to see number of reports in philadelphia since pre- and post- CUA system
- !! Counties not recorded in scraped data pre-2016; 764 cases need counties assigned
- chatted with Kai about how to parse the documents
- checkin the urls because they STINKY (922 removed from public access)
  - 311 go to DA decertified report (https://www.dhs.pa.gov/docs/OCYF/Pages/DA-Certification.aspx)
  - 279 return error (https://auth-agency.pa.egov.com/sites/HumanServices/docs/OCYF/Pages/Unlinked-Report.aspx)
  - 161 go to unlinked (https://www.dhs.pa.gov/docs/OCYF/Pages/Unlinked-Report.aspx)
  - 88 go to DA certification 404 (https://auth-agency.pa.egov.com/sites/HumanServices/docs/OCYF/Pages/DA-Certification.aspx)
  - 79 another flavor of decert (https://www.dhs.pa.gov/docs/OCYF/Pages/Decertification.aspx)
  - 4 go to more decertification (https://auth-agency.pa.egov.com/sites/HumanServices/docs/OCYF/Pages/Decertification.aspx)
  -

**To Do Next**
- make github repo for kai to use
- figure out what kai's reporting credits will be

_Abuse Rates_

- scrape counties and assign to cases pre-2016 in order to evaluate CUA system
- scrape whether family was known to agency pre-event

#### 7 May, 2024

**Work Completed**

_Lawsuit database_
- Deesarine finished pulling the CoCP cases, not a lot but i think it makes sense
- Didn't pull catholic suits before 2013 because they weren't a CUA then

_Abuse Rates_
- Scraped all report URLs and info from https://www.dhs.pa.gov/docs/OCYF/Pages/Fatality-Reports.aspx using https://www.webscraper.io/
  - 3,305 reports pulled
- saved sitemap in Act 33 folder
- processed scraped data in Excel to clean and parse some information
  - set data to be a table named `Reports`
  - source URL is same for all rows, deleted column
  - `info` column has some further detail to parse (region, county, sex, and age)
    - PA lists "gender" -- changed it to sex because the actual data uses sex, not gender
    - removed extra spaces by find-and-replace on all double spaces to replace with single space; repeated until no douple spaces remain
    - text-to-columns feature in excel, used the colon separators to parse out each new column value
    - manually cleaned rows that did not parse correctly (7 total)
      - 1 was not a real record << deleted
      - 3 had a missing `:` after `Region`
      - 1 was missing `:` after `Region` and `County`
      - 2 misnamed the region as county
    - deleted info column because after cleaning, all rows contained same value
  - `region` column cleaning
    - 1 had no region, county, gender, or age << replacing with `NULL`
    - 3 were missing `:` after `county` << manually moved info over
    - created new column `further_info` to indicate whether county/sex/age are reported in the document. this will likely be a temporary column
      - `Yes` = search in the document for more information on county/sex/age
      - `No` = do not search in the document for more information on county/sex/age
      - following columns for county/sex/age left blank, not filled with `NULL`
    - Find and replace to remove everything but the actual region from the values
    - removed all trailing and leading spaces
  - `county` column cleaning
    - 3 had no `:` after `sex` << manually moved info over
    - find and replace on "gender" to remove from county names
    - removed all trailing and leading spaces
  - `sex` column cleaning
    - 1 had no sex or age << replaced with `NULL`
    - 2 had "&n" after sex, removed and filled age with `NULL`
    - 7 had no `:` after `age` << manually moved info over
    - 5 had "Unknown Age" or "unk age" << replaced with `NULL`
    - find and replace on "age" to remove from sex
    - removed all trailing and leading spaces
  - `age` column cleaning
    - create new `trim_age` column and populate Flash Fill to removed leading and trailing spaces
    - delete old `age` column and rename `trim_age` to be `age`
    - standardize less than 1 day to `< 1 day` (includes 0 days,

**To Do**
- Finish cleaning columns

### April

#### 26 April, 2024

- Began pulling suits from PACER; I expect this to have far fewer suits. Agencies completed:
  - NET community care (searched `NET` and `Northeast Treatment Centers`)
  - Asociacion Puertorriquenos en Marcha
  - Turning points
- Learned the best way to confirm whether we have a case is to search the last 5 digits in the case ID because the initial list is not the full ID of the case
- Also learned that PACER does not work on broswers with cookie protections
- Marking cases unrelated with: American Disabilities Act, labor/employment
- Not tracking suits from before 2009

#### 25 April, 2024

- Matched cases to records in database, marked new Unrelated cases as not CUA relevant.
- Going through the rest of the cases and determining if they are relevant
- Case 060302462 was weird, it had no documents but seemed to be about a contract dispute. However, children were named as plaintiffs, and Tabor was listed as a defendant. So, I marked it as related and added a comment.
- A lot of the catholic services cases are of abuse from the 1970s and filed after the 2018 grand jury report. There is a pattern among those suits where they name a school that the church also operated.

#### 24 April, 2024

- Deesarine continued to find and log lawsuits, completing Tabor and Wordsworth. (There were no suits agains Wordsworth). She is continuing to look into cases from Catholic Community Services. This CUA is proving challening because there may be some cases of child abuse that are just related to the church, and not its foster care services.

#### 19 April, 2024

- continued working on/finishing dashboard to collect most figures needed for analysis
- added functionality to make the dashboard a useful tool for exploring cases
- sent steve PACER case on Tamiera Harris' suit against the city for retaliating to her complaint about DHS

#### 18 April, 2024

- Began refining new dashboard to display CoCP stats
- Finished boolean of whether cases are CUA related

#### 17 April, 2024

- Deesarine pulled more documents for APM/NET/Turning points
- Discovered that APM set up another company, Pradera corp, to take over foster care so we added that to the list of searches
- wrote summaries of new cases
- started boolean of whether cases are related to CUA operations or not

#### 16 April, 2024

**Work Completed**

Pull more lawsuits from CUAs

- Searched for APM, found a lot of APM Properties INC but those are not the same company, also excluded APM realty, APM restaraunt group
- phoenetic search for Asociacion Puertorriquenos En Marcha resulted in 8K+ suits, repeated with no phoenetic and removed accents to reveal 25
- deesarine pulled the lawsuits for the rest, only finding a handful

#### 15 April, 2024

**Work Completed**

Finished summarizing PACER cases. Now filling in record with any remaining CoCP and PACER lawsuits. List of agencies to look at in the initial instructions written at start of this project.

- When searching NET Community care, only found four cases we've already captured
- Northeast Treatment Centers found far more cases ()
- Case ID 170600592 (ESURANCE INSURANCE COMPANY VS BOWSER ETAL) is confusing because it's not about a kid in CUAs, but Nadeem Bezar is involved, he's just representing the CUA side against an insurance agency. Sent Steve a quick note to see what he wants to do.
- downloaded all court records for NET

**To Do Next**

- Make sure that there are no duplicates among NET cases
- Summarize new NET cases
- pull rest of lawsuits for other CUAs

#### 11 April, 2024

**Work Completed**

Talked with steve about act 33 -- key info to get is just date, was family known to system, whether fatality or near fatality, county of origin. I think i can scrape that much more easily from the detailed reports because it's all on the first page and is structured the same all the way back to 2009. I need Kai's help with this, probably have to use PDF plummer

determined that all related CoCP cases in database have all needed info, moved on to write summaries for relevant PACER cases that have documents (filter by basic facts being empty and file being not empty)

**To Do Next**

Finish writing summaries for PACER, which is in the sandbox view

#### 8 April, 2024

**Work Completed**

Finished adding documents to COCP and writing summaries

**To Do Next**

Go through PACER and CoCP and look for suits that are not in the database

#### 3 April, 2024

**Work Completed**

Started going through lawsuits and cleaning and completing existing entries
1. Filtered lawsuits by `Summary` is `incomplete`; `OK to have missing doc` is none of `OK to be missing | No Documents | Duplicated Elsewhere`; and `Flag!` is none of `Unrelated`
2. Identified duplicates and attached to duplicate case, then filtered out of selection
3. Identified 7 cases in which a summary is required, four of which have no Documents:
   1. 201102540
   2. 220400827
   3. 220402299
   4. 230601794
4. Downloaded all documents, flagging `201102540` as a potential major case -- this is a potential example that the city is trying to pass the lawsuit on to Bethanna CUA instead of take its own responsibility

**To Do Next**

- Attach files to cases
- write summaries
- fill out missing info

### March

#### 28 March, 2024

**Work Completed**

Installed Python, Pandas, and Jupyter notebook desktop version; started methodology of scraping

**To Do Next**

- Add regex syntax to methodology, add sample of report to methodology, focus on CUA lawsuit work

#### 26 March, 2024

**Work Completed**

Reorganized the document Steve put together to group the analysis I need to do by theme/questions its answering instead of the data source I'll be using. This organization is:

1. Lawsuit database -- to explore how people have saught accountability through suing the CUA System
2. Abuse rates of children once inside the system -- understand the rates and disparities between data at the state and federal levels; understand where Philly lands compared to the rest of the state
3. Casey Foundation call to reduce foster care population by 50% since 2010 -- to understand how many families may not have needed separation at all
4. Berkeley Media Studies on foster care panic -- to understand what the research shows and how it can incorporate into the story

Set up everything and created a timeline in Asana.

**To Do Next**
