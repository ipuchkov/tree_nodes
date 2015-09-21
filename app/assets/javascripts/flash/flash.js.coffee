@init_flash = ->
  fade_flash = ->
    $('#flash_notice').delay(2000).fadeOut 'slow'
    $('#flash_warning').delay(2000).fadeOut 'slow'
    $('#flash_error').delay(2000).fadeOut 'slow'
    return

  fade_flash()

  show_ajax_message = (msg, type) ->
    $('#flash-message').html '<div id="flash_' + type + '">' + msg + '</div>'
    fade_flash()
    return

  $(document).ajaxComplete (event, request) ->
    msg = request.getResponseHeader('X-Message')
    type = request.getResponseHeader('X-Message-Type')
    if msg
      show_ajax_message msg, type
    return
