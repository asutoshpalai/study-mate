$ ->
  $('#createpost').submit (event) ->
    event.preventDefault()
    form = $('#createpost')
    msg = form[0].msg.value
    $.post(
      form.attr('action')
      form.serialize()
      (data) ->
        if (data != "failed")
          if (!$('#msgs ol').length)
            $('#msgs').html(
              '<ol></ol>'
            )
          $('#msgs ol').append(
            '<li>' + data + '</li>'
          )


    )
    return false
