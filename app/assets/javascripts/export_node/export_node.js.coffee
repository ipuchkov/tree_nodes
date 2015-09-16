@init_export_node = ->
  $('.export').click (evt) ->
    id = $(evt.target).attr('data-id')
    if id
      $.post "nodes/#{id}/add_to_cache", (data) ->
        return
