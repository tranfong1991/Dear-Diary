# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
      flashCallback = ->
        $(".alert").fadeOut()
      $(".alert").bind 'click', (ev) =>
        $(".alert").fadeOut()
      setTimeout flashCallback, 3000

      @onSearchResultClick = (created_at, entry_id) -> 
        $('#diary-date').html(created_at);
        $('#edit-btn').bind 'click', (ev) =>
          location.href = "#{entry_id}/edit";
        $('#diary-modal').modal('show');

        $.ajax
          url: "https://deerdiary.herokuapp.com/api/entries/#{entry_id}"
          type: "GET"
          success: (data) ->    
            $('#diary-content').html(data.content);