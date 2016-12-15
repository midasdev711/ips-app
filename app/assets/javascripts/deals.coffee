DealsController = Paloma.controller('Deals')

DealsController.prototype.show = () ->
  $document = $(document)

  $document.ready ->
    $document.on 'ajax:complete', '#deal-form', (e, xhr) ->
      $('#deal-form-container').html(xhr.responseText)
      $document.foundation();

    $document.on 'change', '.residual-unit-select', (e) ->
      e.stopPropagation()
      $select = $(e.target)
      $input = $($select.data('target'))
      $input.val(0)

    $document.on 'change', '.residual', (e) ->
      e.stopPropagation() if !$(e.target).parents('.product').find(':checkbox').is(':checked')

    $document.on 'change', "#deal-form", (e) ->
      $('#deal-form').trigger('submit')

    $document.on 'click', '.tier', (e) ->
      e.preventDefault()
      $button = $(e.target)
      $li = $button.parent('li')
      $('#tier').val(if $li.is('.current') then '' else $button.data('tier'));
      $('#deal-form').trigger('submit')

    $document.on 'click', '.toggle-products', (e) ->
      e.preventDefault()
      $a = $(e.target)
      $($a.data('target')).toggle()

    $document.on 'click', '.category h3', (e) ->
      $category = $(e.target).parent()
      $category.find('.premium').toggle()

    $document.on 'keyup', '.premium', (e) ->
      $input = $(e.target)
      $input.siblings('.overridden').val(if $input.val() == '0' then false else true)

    handleProductChange = (e) ->
      $('#products_changed').val(true)

    $document.on 'change', '#lender-l-products input', handleProductChange
    $document.on 'change', '#lender-l-products select', handleProductChange

    $document.on 'click', '.show-interest-rate', (e) ->
      $span = $(e.target).hide()
      $($span.data('target')).show()

    $document.on 'change', '.insurance-term-checkbox', (e) ->
      $inputCheckbox = $(e.target)
      $inputHidden = $inputCheckbox.next(':hidden')
      $inputHidden.val !$inputCheckbox.is(':checked')

    $document.on 'click', '.show-cost-of-borrowing', (e) ->
      e.preventDefault()
      $a = $(e.target)
      $($a.data('target')).toggle()
