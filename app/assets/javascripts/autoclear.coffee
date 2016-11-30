$(document).on "ready page:change page:load", ->
  $('body').on 'focusin', '[data-autonumeric]', (e) ->
    display_value = $(this).val()
    raw_value = $(this).autoNumeric 'get'

    $(this).val ''
    $(this).attr 'placeholder', display_value
    $(this).data 'raw-value', raw_value

  $('body').on 'focusout', '[data-autonumeric]', (e) ->
    current_value = $(this).val()
    prev_value = $(this).data('raw-value')

    if current_value == ''
      $(this).autoNumeric 'set', prev_value

    $(this).attr('placeholder', '')
    $(this).data('raw-value', '')
