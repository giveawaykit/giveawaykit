SG.Giveaways.Start =

  _sg: _SG

  initialize: ->
    if @modalEl().length
      @attachButtonEvents()
      if @justSubscribed()
        @triggerStartModal()
      else
        @initStartModal()

  initStartModal: ->
    $(document).on 'hidden.bs.modal', '#start_giveaway_modal', ->
      $('#start_giveaway_modal').removeData('bs.modal')
    $(document).on 'ajaxSuccess', (response) =>
      @attachModalEvents()

  attachModalEvents: ->
    if @modalEl().find('.datetime-picker-input').length
      SG.UI.DatetimePickers.initialize @modalEl().find('.datetime-picker-input')

  attachButtonEvents: ->
    $(document).on 'click', '#start_giveaway_modal .approve.btn', (e) =>
      @moveForward()

  triggerStartModal: ->
    $(document).on 'ajaxSuccess', =>
      @modalEl().find(".modal-step[data-modal-step='1']").hide()
      @modalEl().find(".modal-step[data-modal-step='2']").show()
      $('#start_giveaway_end_date').val @_sg.CurrentGiveaway.proposedEndDate
      $('#start_giveaway_tab_name').val @_sg.CurrentGiveaway.proposedTabName
      @attachModalEvents()
    $('#start_giveaway').trigger 'click'

  justSubscribed: ->
    @_sg.CurrentUser.justSubscribed.length && @_sg.CurrentPage.isSubscribed?

  moveForward: ->
    current = @currentStepEl()
    next = @nextStepEl()
    if next.find('#no_subscription').length
      SG.UI.Loader.createOverlay(true)
      @redirectToSubPlans()
    else if next.find("#trigger_start_giveaway").length
      SG.UI.Loader.createOverlay(true)
      @startGiveaway()
    else
      current.hide()
      next.show()

  redirectToSubPlans: ->
    $.ajax
      url: @_sg.Paths.subscriptionPlans
      type: 'POST'
      data:
        starting: true
        end_date: $('#start_giveaway_end_date').val()
        custom_tab_name: $('#start_giveaway_tab_name').val()
      success: =>
        top.location.href = @_sg.Paths.subscriptionPlans

  startGiveaway: ->
    $('#step_one form').submit()

  currentStep: ->
    @currentStepEl().data('modal-step')

  currentStepEl: ->
    @modalEl().find('.modal-step:visible')

  nextStep: ->
    parseInt(@currentStep()) + 1

  nextStepEl: ->
    @modalEl().find(".modal-step[data-modal-step='#{@nextStep()}']").first()

  denyButtonEl: -> @modalEl().find('.deny.btn')

  approveButtonEl: -> @modalEl().find('.approve.btn')

  modalEl: -> $('#start_giveaway_modal')
