$ ->
  $('#createpost').submit (event) ->
    event.preventDefault()
    form = $('#createpost')
    msg = form[0].msg.value
    $.post(
      form.attr('action')
      form.serialize()
      (data) ->
        if (data == "true")
          if (!$('#msgs').length)
            $('#msgs-container').html(
              '<ol id="msgs"></ol>'
            )
          $('#msgs').append(
            '<li class = "msg">' + msg + '</li>'
          )


    )
    return false
