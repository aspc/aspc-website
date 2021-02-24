// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
jQuery(function() {
    $('select[id*="time"]').wrap('<div class="select">');

    $(".expand-search-options").on("click", function (e) {
        e.preventDefault();
        $(".expandable").toggle('slow', 'swing', function () {
            if ($('.expandable').css('display') == 'block') {
                $(".expand-search-options").text("Hide advanced search");
            } else {
                $(".expand-search-options").text("Show advanced search");
            }
        });
    });

    var expanded = false;

    $("#expand-course-planner").on("click", function(e) {
        $(".application-content-container").toggleClass("is-fluid");
        if (expanded) {
            $("#expand-course-planner-text").text("Expand course planner");
            $("#course-search-form-container").removeClass("is-2-widescreen is-2-fullhd");
            $("#course-list-container").removeClass("is-3-widescreen is-3-fullhd");
            
        } else {
            $("#expand-course-planner-text").text("Shrink course planner");
            $("#course-search-form-container").addClass("s-2-widescreen is-2-fullhd");
            $("#course-list-container").addClass("is-3-widescreen is-3-fullhd");
        }
        expanded = !expanded;
    });
});

// We have to bind click events for 
// collapsing/expanding courses in course search
// results after DOM changes since those are
// asynchronously fetched and added to the page
// https://stackoverflow.com/questions/2762597/how-to-bind-to-javascript-events-after-the-dom-changes

$(document).on('click', '.more-details-chevron', function(e) {
    var chevrons = $(e.target).closest(".more-details-chevron");
    chevrons.children("span[class^='chevron-']").toggle();
    var container = chevrons.closest('.message');
    container.children('.message-body').toggle();
});