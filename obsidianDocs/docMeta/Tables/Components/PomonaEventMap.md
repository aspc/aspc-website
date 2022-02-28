---
type: component
status: 
---
parent: [[Pomona Events Scraping]]



```ad-abstract
title:Responsibility
This component is responsible for providing a mapping between events found on pomona's website and the generic [[Event]] 
```



## Whiteboarding

```plantuml

class PomonaEventMap {

{field} event_id (the id attached to the event on the pomona website)

{field} mapped_id (the id of the Event model it is transformed into)

}
```




## Methods

```dataview
list 
from "docMeta/Tables/Methods" and [[]]
```



```button
name Create Method
type command
action QuickAdd: Create Method
```


