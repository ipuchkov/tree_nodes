@init_operate_node = ->
  $('.operate').click (evt) ->
    target = $(evt.target)
    if target.hasClass('new')
      id  = target.attr('data-parent-id')
      url = "cached_nodes/new?parent_id=#{id}"
    if target.hasClass('edit')
      id  = $(evt.t).attr('data-id')
      url = "cached_nodes/#{id}/edit"
    if id
      $.ajax
        url: url
        success: (data) ->
          $(document.body).append(data)
          init_apply_changes()

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