



```ad-abstract
title:Interface
~~~typescript
interface PomonaTrumbaEvent {
	eventID:string;
	template:string;
	title:string;
	description:stringHTML;
	location:string;
	webLink:string;
	startDateTime:string;
	endDateTime:string;
	dateTimeFormatted:string;
	allDay:bool;
	startTimeZoneOffset:string;
	endTimeZoneOffset:string;
	canceled:bool;
	openSignUp:bool;
	reservationFull:bool;
	pastDeadline:bool;
	pastCancelDeadline:bool;
	requiresPayment:bool;
	refundsAllowed:bool;
	waitingListAvailable:bool;
	customFields:Object[]
	permaLinkUrl:string;
	eventActionUrl:string;
	categoryCalendar:string;
	registrationTransferTargetCount:number;
	regAllowChanges:bool;
}
~~~
```
