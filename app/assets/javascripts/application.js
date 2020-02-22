// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require moment
//= require underscore
//= require clndr-rails
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$( document ).ready(function() {
  
    // show spinner on AJAX start
    $(document).ajaxStart(function(){
        $(".spinner").show();
    });
  
    // hide spinner on AJAX stop
    $(document).ajaxStop(function(){
        $(".spinner").hide();
    });

    // Has to bind to 'document' first because event binding
    // will stop working once switch page, due to components 
    // being removed and added back.
    $(document).on("hidden.bs.modal", ".modal", function(){
        $("#diary-date, #diary-content").html("");
    });
});