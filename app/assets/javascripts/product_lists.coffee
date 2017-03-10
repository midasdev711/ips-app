ProductListsController = Paloma.controller('ProductLists')
ProductListsController.prototype.edit = () ->
  $document = $(document);

  $document.on 'ready page:load', ->

    $document.on 'click', '.add', (e) ->
      e.preventDefault()
      $element = $(e.target)

      template = $('#' + $element.data('template')).html()
      template = template.replace(/(\w+\[[\w_]+_attributes\])(\[\d+\])/g, '$1' + '[' + new Date().getTime() + ']')

      $target = $('#' + $element.data('target'))

      $target.append(template)
      $target.find('select').trigger('change');

      # $document.trigger('refresh_autonumeric');

    $document.on 'click', 'a.destroy', (e) ->
      e.preventDefault()
      $tr = $(e.target).parents('tr')
      $tr.hide()
      $input = $tr.find('input[name$="[_destroy]"]')
      $input.val(true)


    $document.on 'click', '.insurance-rate-variation .add-insurance-rate', (e) ->
      e.preventDefault()

      $element = $(e.target)

      $insuranceRateVariation = $element.parents('.insurance-rate-variation')
      $insuranceRateVariationInsuranceRates = $insuranceRateVariation.find('.insurance-rates')

      template = $insuranceRateVariation.find('.insurance-rate-template').html()
      template = template.replace(/(product_list\[insurance_policies_attributes\]\[\d+\]\[insurance_rates_attributes\])(\[\d+\])/g, '$1' + '[' + new Date().getTime() + ']')

      $insuranceRateVariationInsuranceRates.prepend(template)

    $document.on 'click', '.insurance-rate-variation .remove-insurance-rate', (e) ->
      e.preventDefault()

      $element = $(e.target)

      $insuranceRate = $element.parents('.insurance-rate')
      $insuranceRate.hide()

      $insuranceRateDestroyInput = $insuranceRate.find('input[name$="[_destroy]"]')
      $insuranceRateDestroyInput.val(true)


    $('#province').on 'change', (e) ->
      selected = $('option:selected', e.target)
      $('#pst').text(selected.data('pst'))
      $('#gst').text(selected.data('gst'))

    autoNumericOptions = { aPad: false }

    $('.product-profit, #total-profit').autoNumeric('init', autoNumericOptions).autoNumeric('update')

    $document.on 'keyup', '.product-retail-price, .product-dealer-cost', (e) ->
      $target = $(e.target)

      $retailPriceInput = $target.closest('tr').find('.product-retail-price')
      $dealerCostInput  = $target.closest('tr').find('.product-dealer-cost')

      retailPrice = $retailPriceInput.autoNumeric('init', autoNumericOptions).autoNumeric('get') || $retailPriceInput.data('raw-value')
      dealerCost  = $dealerCostInput.autoNumeric('init', autoNumericOptions).autoNumeric('get') || $dealerCostInput.data('raw-value')

      profit = retailPrice - dealerCost

      $target.closest('tr').find('.product-profit').autoNumeric('init', autoNumericOptions).autoNumeric('set', profit)

      total = $.makeArray($('.product-profit')).reduce ((memo, node) ->
        memo + parseInt $(node).autoNumeric('get')
      ), 0

      $('#total-profit').autoNumeric('set', total)
