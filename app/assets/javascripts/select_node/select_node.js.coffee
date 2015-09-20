@init_select_node = ->
  export_link  = $('.export')
  edit_link    = $('.edit')
  new_link     = $('.new')
  delete_link  = $('.delete')
  nodes        = $('.nodes')
  cached_nodes = $('.cached_nodes')

  nodes.click (evt) ->
    select_node(nodes, $(evt.target), [export_link], false)
    return

  cached_nodes.click (evt) ->
    select_node(cached_nodes, $(evt.target), [edit_link, new_link, delete_link], true)

  select_node = (container, target, links, parent) ->
    if target.is?('span')
      id = target.attr('id')

      container.find('span').removeClass('selected')
      target.addClass('selected')
      unless target.hasClass('deleted')
        $(links).each (ind, elm) ->
          if parent && $(elm).hasClass('new')
            $(elm).attr('data-parent-id', id)
          else
            $(elm).attr('data-id', id)
