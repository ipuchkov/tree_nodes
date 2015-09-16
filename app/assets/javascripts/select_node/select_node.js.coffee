@init_select_node = ->
  link = $('.export')

  $('.nodes').click (evt) ->
    target = $(evt.target)
    if target.is?('span')
      id = target.attr('id')

      $('.nodes span').removeClass('selected')
      target.addClass('selected')
      link.attr('data-id', id)
