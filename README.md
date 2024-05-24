# README

## Background

Pennsylvania publishes reports on child fatalities and near fatalities as a result of child abuse. The reports include the age, sex, county, and date of the incident, as well as whether the family was known to the local department of human/family services in the 16 months preceding the incident.

### Goal of Analysis

Parse the 1st page of the reports to identify the county where the incident occurred and whether the family was known to that county. There are 3.305 total records of reports.

### Data

-   [​Child Fatality/Near Fatality Reports](https://www.dhs.pa.gov/docs/OCYF/Pages/Fatality-Reports.aspx) --- A table of the reports with some information and URLs to the actual reports. | [Metadata](URL)
  - A scraped `.xlsx` version of this data exists in this repo. It may be periodically updated as we clean/refine it.

### Limitations

> [!WARNING]
> Counties not recorded in scraped data pre-2016; 764 cases need counties assigned

> [!WARNING]
> 922 Reports have URLs that mention a DA De-certification, which means that the report is unavailable. Most of these are a result of the DA determining that those incident reports were not a result of child abuse. These all share one of 6 common URLs:

1. https://www.dhs.pa.gov/docs/OCYF/Pages/DA-Certification.aspx
2. https://auth-agency.pa.egov.com/sites/HumanServices/docs/OCYF/Pages/Unlinked-Report.aspx
3. https://www.dhs.pa.gov/docs/OCYF/Pages/Unlinked-Report.aspx
4. https://auth-agency.pa.egov.com/sites/HumanServices/docs/OCYF/Pages/DA-Certification.aspx
5. https://www.dhs.pa.gov/docs/OCYF/Pages/Decertification.aspx
6. https://auth-agency.pa.egov.com/sites/HumanServices/docs/OCYF/Pages/Decertification.aspx

## Parsing

*This is where we will document the code used to parse these reports*
