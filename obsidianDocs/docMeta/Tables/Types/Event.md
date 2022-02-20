



```ad-abstract
title:Interface
~~~typescript
interface Event {
	_id: uuidv4
	status: "Pending"|"Approved"| "Rejected";
	name:string;
	location:string;
	description:string;
	host:string;
	link:string;
	college: "All Colleges" | "Pomona" | "Pitzer" | "Scripps"| "Claremont McKenna" | "Harvey Mudd"
	startDate: string;
	endDate: string;

}
~~~
```


```ad-note
title:Description
The Event object represents the interface that will conform Events panel in the ASPC admin page
```
