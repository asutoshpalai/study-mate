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
          $('#postbox').val('')


    )
    return false

  $('#fileupload').submit (event) ->
    event.preventDefault()
    form = $('#fileupload')
    data = new FormData()
    data.append 'file', form[0].file.files[0]
    $.ajax(
      url:form.attr('action')
      type: 'post'
      contentType: false
      processData: false
      data: data
      success: (data) ->
        if (data != "failed")
          if (!$('#files ol').length)
            $('#files').html(
              '<ol></ol>'
            )
          $('#files ol').append(
            '<li>' + data + '</li>'
          )
          if (!$('#msgs ol').length)
            $('#msgs').html(
              '<ol></ol>'
            )
          $('#msgs ol').append(
            '<li>' + data + '</li>'
          )


    )
    return false

  $('#addtrackuser').submit (event) ->
    event.preventDefault()
    form = $(this)
    $.post(
      form.attr('action')
      form.serialize()
      (data) ->
        if (data != "failed")
         $('#userslist').html(data)

    )
    return false

