@init_edit_node = ->
  $('.edit').click (evt) ->
    id = $(evt.target).attr('data-id')
    if id
      $.ajax
        url: "cached_nodes/#{id}/edit"
        success: (data) ->
          $(document.body).append(data)
          init_apply_changes()

@init_apply_changes = ->
  $('.ajaxed_form').submit (evt) ->
    form_data =  $(this).serialize()
    $.ajax
      type: 'patch'
      url:  $(this).attr('action')
      data: $(this).serialize()
      success: (data) ->
        $('.cached_nodes .tree_view').html(data)
        $('.popup_container').remove()
    false

  $('.cancel').click (evt) ->
    $('.popup_container').remove()
