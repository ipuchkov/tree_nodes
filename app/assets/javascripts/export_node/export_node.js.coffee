@init_export_node = ->
  $('.export').click (evt) ->
    id = $(evt.target).data('id')
    if id
      $.post "nodes/#{id}/add_to_cache", (data) ->
        return
