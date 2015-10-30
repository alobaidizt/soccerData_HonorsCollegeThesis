`import Ember from 'ember'`

ApiService = Ember.Service.extend

  getAllKeywords: ->
    # returns a promise
    $.ajax({
      type: "GET",
      url: "https://127.0.0.1:444/api/keywords/",
    })

  getKeywordByName: (name) ->
    # returns a promise
    $.ajax({
      type: "GET",
      url: "https://127.0.0.1:444/api/keywords/name/#{name}",
    })

  updateKeywordByName: (name, mask) ->
    # returns a promise
    $.ajax({
      type: "PUT",
      url: "https://127.0.0.1:444/api/keywords/name/#{name}",
      data:
        mask: mask
    })

`export default ApiService`
