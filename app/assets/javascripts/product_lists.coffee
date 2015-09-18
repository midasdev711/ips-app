ProductListsController = Paloma.controller('ProductLists')
ProductListsController.prototype.edit = () ->
  $document = $(document);

  $document.on 'ready page:load', ->
    $document.on 'change', '.loan-type', (e) ->
      $select = $(e.target);
      $select.parents('.insurance-policy-form').removeClass().addClass('insurance-policy-form ' + $select.val());

    $document.on 'click', 'a.destroy', (e) ->
      e.preventDefault()
      $tr = $(e.target).parents('tr')
      $tr.hide()
      $input = $tr.find('input[name$="[_destroy]"]')
      $input.val(true)

    $('.add').on 'click', (e) ->
      e.preventDefault()
      $button = $(e.target)

      template = $('#' + $button.data('template')).html()
      template = template.replace(/(\w+\[[\w_]+_attributes\])(\[\d+\])/g, '$1' + '[' + new Date().getTime() + ']')

      $target = $('#' + $button.data('target'))

      $target.append(template)
      $target.find('select').trigger('change');

      $document.trigger('refresh_autonumeric');


    $('#province').on 'change', (e) ->
      selected = $('option:selected', e.target)
      $('#pst').text(selected.data('pst'))
      $('#gst').text(selected.data('gst'))

    autoNumericOptions = { aPad: false }

    $('.product-profit, #total-profit').autoNumeric('init', autoNumericOptions).autoNumeric('update')

    $document.on 'keyup', '.product-retail-price, .product-dealer-cost', (e) ->
      retailPrice = $(e.target).closest('tr').find('.product-retail-price').autoNumeric('init', autoNumericOptions).autoNumeric('get') || 0
      dealerCost = $(e.target).closest('tr').find('.product-dealer-cost').autoNumeric('init', autoNumericOptions).autoNumeric('get') || 0

      profit = retailPrice - dealerCost

      $(e.target).closest('tr').find('.product-profit').autoNumeric('init', autoNumericOptions).autoNumeric('set', profit)

      total = $.makeArray($('.product-profit')).reduce ((memo, node) ->
        memo + parseInt $(node).autoNumeric('get')
      ), 0

      $('#total-profit').autoNumeric('set', total)
