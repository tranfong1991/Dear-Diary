# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
      flashCallback = ->
        $(".alert").fadeOut()
      $(".alert").bind 'click', (ev) =>
        $(".alert").fadeOut()
      setTimeout flashCallback, 3000

      options = { 
        weekday: 'long',
        year: 'numeric',
        month: 'long', 
        day: 'numeric', 
        timeZone: 'UTC' 
      };

      @onSearchResultClick = (entry) -> 
        entry_created_at = new Date(entry.created_at);
        $('#diary-date').html(entry_created_at.toLocaleDateString("en-US", options));
        $('#edit-btn').bind 'click', (ev) =>
          location.href = "#{entry.id}/edit";
        $('#diary-content').html(entry.content);
        $('#diary-modal').modal('show');