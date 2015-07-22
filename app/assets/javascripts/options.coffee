OptionsController = Paloma.controller('Options')
OptionsController.prototype.show = () ->
  $document = $(document)

  $document.ready ->
    $document.on 'ajax:complete', '#options-form', (e, xhr) ->
      $('#options-form-container').html(xhr.responseText)

    $document.on 'change', '.residual-unit-select', (e) ->
      e.stopPropagation()
      $select = $(e.target)
      $input = $($select.data('target'))
      $input.val(0)

    $document.on 'change', '.residual', (e) ->
      e.stopPropagation() if !$(e.target).parents('.product').find(':checkbox').is(':checked')

    $document.on 'change', "#options-form", (e) ->
      $('#options-form').trigger('submit')

    $document.on 'click', '.tier', (e) ->
      e.preventDefault()

      $button = $(e.target)
      $('#buydown-tier').val($button.data('tier'));

      $li = $button.parent('li')
      $li.siblings().removeClass('current')
      $li.addClass('current')

      $('#options-form').trigger('submit')

    $document.on 'click', '.toggle-products', (e) ->
      e.preventDefault()
      $a = $(e.target)
      $($a.data('target')).toggle()

    handleProductChange = (e) ->
      $('#products_changed').val(true)
    $document.on 'change', '#option-l-products input', handleProductChange
    $document.on 'change', '#option-l-products select', handleProductChange

    $document.on 'click', '.show-interest-rate', (e) ->
      $span = $(e.target).hide()
      $($span.data('target')).show()

    $document.on 'change', '#option-r-interest-rate', (e) ->
      $input = $('#buydown-tier')
      $input.val($input.data('tier'))

    $document.on 'change', '.insurance-term-checkbox', (e) ->
      $inputCheckbox = $(e.target)
      $inputHidden = $inputCheckbox.next(':hidden')
      $inputHidden.val !$inputCheckbox.is(':checked')

    $document.on 'click', '.show-cost-of-borrowing', (e) ->
      e.preventDefault()
      $a = $(e.target)
      $($a.data('target')).toggle()
