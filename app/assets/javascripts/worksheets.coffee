WorksheetsController = Paloma.controller('Worksheets')

WorksheetsController.prototype.show = ->
  $document = $(document)

  $document.on "ready page:change page:load", ->
    $('.cross-copy').on 'click', (e) ->
      e.preventDefault()

      copyValue = (src, dst) ->
        $src = $(src)
        $dst = $(dst)

        $dst.val('')

        if $src.data('auto-numeric')?
          $dst.autoNumeric 'set', $src.autoNumeric('get')
        else
          $dst.val($src.val())

      property = $(e.currentTarget).data('property-name');

      property.split(' ').forEach (elem) ->
        candidates = $(e.currentTarget).parent().siblings().find('input[type=text]')
        [left, right] = $.grep candidates, (obj) ->
          $(obj).attr('id').indexOf(elem) isnt -1

        if left? and right?
          if left.value? and (right.value.length is 0 or parseInt(right.value) is 0)
            copyValue(left, right)
            $(right).focus()
          else if right.value? and (left.value.length is 0  or parseInt(left.value) is 0)
            copyValue(right, left)
            $(left).focus()
          $(document).trigger('refresh_autonumeric')

    $('.add').on 'click', (e) ->
      e.preventDefault()
      $button = $(e.target)

      template = $('#' + $button.data('template')).html()
      template = template.replace(/(\w+\[[\w_]+_attributes\]\[\d+\]\[[\w_]+\])(\[\d+\])/g, '$1' + '[' + new Date().getTime() + ']')

      $target = $('#' + $button.data('target'))

      $target.append(template)

      $('[data-autonumeric]:last-child', $target).val('')
      $('[data-autonumeric]:last-child', $target).focus()

      $(document).trigger('refresh_autonumeric');

    $document.on 'change', '.residual-unit-select', (e) ->
      $select = $(e.target)
      $input = $($select.data('target'))
      $input.val(0)

    $document.on 'click', 'a.destroy', (e) ->
      e.preventDefault()
      $block = $(e.target).parents('.interest-rate')
      $block.hide()
      $input = $block.find('input[name$="[_destroy]"]')
      $input.val(true)

    $form = $('form')
    $loanTypeSelect = $('.loan-type-select')

    $form.on('change', ->
      klass = $loanTypeSelect.map ->
        this.value
      .get().join('-to-')
      $form.removeClass().addClass(klass)
    ).trigger('change')

    $('.lender-l .loan-type-select').on 'change', (e) ->
      $selectL = $(e.target)
      $selectR = $('.lender-r .loan-type-select')

      if $selectL.val() is 'finance'
        $selectR.val('finance').readonly().trigger('change')
      else
        $selectR.readonly(false)
