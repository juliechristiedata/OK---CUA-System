Final Regex phrases for each report

# Core Regex phrasing

``` regex /gmi
(?:\n|\r)\d{1,2}(?:(?:\.|(\)))|\.(?:\)))\s[a-zA-z\s]+(?'age'\d+-\w+-old) (?'sex'(?:fem|m)ale)(?:(?: child )|\s)(?'fatality'died |nearly died )on (?'date'\w{3,9}?\s\d{1,2}?\s*,\s\d{4}?).+(?s)(?<=naming )(?'perpetrator'.*?)(?=as the perp)[a-zA-z\s]+.+?(?'known_status'was previously known|had no prior documented)
```


# 2016

## Q4
- removed comma in case 19 for date
