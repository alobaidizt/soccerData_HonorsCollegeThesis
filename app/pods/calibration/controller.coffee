`import Ember from 'ember'`

CalibrationController = Ember.Controller.extend

  showCalibrationWords: false
  keywords:             undefined

  init: ->
    @_super()
    @set 'that', this

    #recognition = new webkitSpeechRecognition()
    #recognition.continuous      = false
    #recognition.interimResults  = false

    #@setProperties
      #recognition:  recognition


    #recognition.onresult = ((event) =>
      #that = window.privateVar
    #recognition.onstart = ->
    #recognition.onstop  = ->
    #recognition.onend   = ->
      #that = window.privateVar
      #that.toggleProperty('isListening')

  addData: ->
    params =
      name: $('#name').val().toLowerCase()
      mask: $('#mask').val().toLowerCase()

    @updateKeywordByName(params.name, params.mask).then ->
      $('#name').val('')
      $('#mask').val('')

  calibrate: ->
    @getAllKeywords()
      .then (data) =>
        @set 'keywords', data.keywords
        @toggleProperty('showCalibrationWords')


  getAllKeywords: ->
    # returns a promise
    $.ajax({
      type: "GET",
      url: "http://localhost:3000/api/keywords/",
    })

  getKeywordByName: (name) ->
    # returns a promise
    $.ajax({
      type: "GET",
      url: "http://localhost:3000/api/keywords/name/#{name}",
    })

  updateKeywordByName: (name, mask) ->
    # returns a promise
    $.ajax({
      type: "PUT",
      url: "http://localhost:3000/api/keywords/name/#{name}",
      data:
        mask: mask
    })
  
  actions:
    addData: -> @addData()
    calibrate: -> @calibrate()

    calibrateWord: () ->
      console.log ''

    test: ->
      name = "new"
      mask = "news"
      @updateKeywordByName(name, mask).then (data) ->
        console.log data

`export default CalibrationController`
