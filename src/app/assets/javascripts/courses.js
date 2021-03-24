// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(function () {
    $('select[id*="time"]').wrap('<div class="select">');

    $(".expand-search-options").click(function (e) {
        e.preventDefault();
        $(".expandable").toggle('slow', 'swing', function () {
            if ($('.expandable').css('display') == 'block') {
                $(".expand-search-options").text("Hide advanced search")
            } else {
                $(".expand-search-options").text("Show advanced search")
            }
        });
    });
});
