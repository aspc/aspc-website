---
type: feature
status: in-progress
---



```ad-note
title:Description
This feature creates a scraping tool which will periodically scrape for events and store them in a specified location
```



```ad-abstract
title:Acceptance Critiera
```


## Research and Design

```ad-note
title:Extracting Data
It turns out there is a URL that can be used

`https://www.trumba.com/calendars/pomona-college-json.json`
This URL gives us the JSON verbatim of the following form: [[PomonaTrumbaEvent]].

```

```ad-note
title: Preventing Duplicates
Given that there is an unique EventID in thte [[PomonaTrumbaEvent]], this field can be used as the key
for a key,value pair where the value represents a UUIDv4 id that would be created for use in the events Database.

To do this, we can create a PomonaEventsMap Table with the fields EventID and UUIDv4.

Everytime an Event from PomonaEvents is scrapped, we can take the eventID and check and see if it exists in the table, if it does then we know not to add it to the Events Table.

If it does not exist, then we know to generate an UUIDv4, add a row containing the eventID and UUIDv4 and then add the transformed event to the Events table.
```

```ad-note
title:Queue

I think a good cycle for this to run is maybe once a day or once a week since the events on the website seem to be well planned out.



```

```ad-note
title: Data Transformation

Going from [[PomonaTrumbaEvent]] -> [[Event]] seems pretty straightforward.

for _id, generate an unique uuidv4 string
for status set it to "Approved"
for name use the *Title* field 
for location use the location field 
for description use description ? 
for host ?
for link use the webLink field
for college use "Pomona"
for startDate use startDateTime
for endDate use endDateTime 

```


## Components 
```dataview
list
from "docMeta/Tables/Components" and [[]]
```



```button
name Create Component
type command
action QuickAdd: Create Component
```





