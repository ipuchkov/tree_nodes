@init_select_node = ->
  export_link  = $('.export')
  edit_link    = $('.edit')
  nodes        = $('.nodes')
  cached_nodes = $('.cached_nodes')

  nodes.click (evt) ->
    select_node(nodes, $(evt.target), [export_link])
    return

  cached_nodes.click (evt) ->
    select_node(cached_nodes, $(evt.target), [edit_link])

  select_node = (container, target, links) ->
    if target.is?('span')
      id = target.attr('id')

      container.find('span').removeClass('selected')
      target.addClass('selected')
      $(links).each (ind, elm) ->
        $(elm).attr('data-id', id)
