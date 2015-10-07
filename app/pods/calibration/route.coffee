`import Ember from 'ember'`

CalibrationRoute = Ember.Route.extend

  model: ->
    @store.find('keyword')

  setupController: (controller, model) ->
    controller.set 'data', model

`export default CalibrationRoute`
