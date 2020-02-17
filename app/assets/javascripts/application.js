// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require activestorage

//= require cable.js

//= require @fullcalendar/core/main.js
//= require @fullcalendar/daygrid/main.js
//= require @fullcalendar/list/main.js

//= require bulma-calendar/dist/js/bulma-calendar.js

//= require slick-carousel/slick/slick.js

//= require froala.js

// Page specific javascript here
//= require events.js
//= require sessions.js
//= require static.js
//= require courses.js
//= require menu.js
//= require course_reviews.js

// initialise fullCalendar
$("#calendar").fullCalendar({});