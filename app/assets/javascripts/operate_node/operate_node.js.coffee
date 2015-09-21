@init_operate_node = ->
  $('.operate').click (evt) ->
    target = $(evt.target)
    allow = false
    if target.hasClass('new')
      id  = target.attr('data-parent-id')
      allow = true
      if id
        url = "cached_nodes/new?parent_id=#{id}"
      else
        url = "cached_nodes/new"
    if target.hasClass('edit')
      id  = target.attr('data-id')
      url = "cached_nodes/#{id}/edit"
    if id || allow
      $.ajax
        url: url
        success: (data) ->
          $(document.body).append(data)
          remove_data()
          init_apply_changes()
    false

@init_delete_node = ->
  $('.delete').click (evt) ->
    id = $(evt.target).attr('data-id')
    $.ajax
      url:  "cached_nodes/#{id}"
      type: 'delete'
      success: (data) ->
        $('.cached_nodes .tree_view').html(data)
        remove_data()

remove_data = ->
  $('.operate').removeAttr('data-id').removeAttr('data-parent-id')

init_apply_changes =(type, url) ->
  $('.ajaxed_form').submit (evt) ->
    form_data =  $(this).serialize()
    $.ajax
      type: $(this).attr('method')
      url:  $(this).attr('action')
      data: $(this).serialize()
      success: (data) ->
        $('.cached_nodes .tree_view').html(data)
        $('.popup_container').remove()
    false

  $('.cancel').click (evt) ->
    $('.popup_container').remove()
    false
