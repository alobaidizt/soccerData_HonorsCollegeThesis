`import Ember from 'ember'`

SplashController = Ember.Controller.extend
  showScript:	false
  isListening:  false
  showResult:   false
  recognition:      undefined
  currentIndex:     undefined 

  init: ->
    @_super()

    recognition = new webkitSpeechRecognition()

    recognition.maxAlternatives = 10

    keywords = ['shoot', 'make', 'inbound','bounce', 'lose', 'steal', 'pass', 'foul', 'free throw', 'miss', 'rebound', 'turnover', 'blue', 'red']
    bbActions = ['make','miss','grab','pass','lose','shoot','turnover-on','take','foul-by','foul-on','no-basket-for','steal-for','inbound','bounce']
    output = new Array();
    replacements = [['number ', '#', ],['makes','make'],['first','1st'],['second','2nd'],['free throw','free-throw'],['mrs.','miss'],['misses','miss'],['crabs','grab'],['grabs','grab'],['passes','pass'],['passed','pass'],['shoots','shoot'],['bounces','bounce'],['inbounds','inbound'],['loses','lose'],['ride','red'],['read','red'],[' red','-red'],['lou', 'blue'],[' blue','-blue'],['turn over','turnover'],['turnover on','turnover-on'],['ii','2nd'],['takes','take'],['fouled','foul'],['foul by','foul-by'],['foul on','foul-on'],['no basket for','no-basket-for'],['ball to','ball-to'],['ball from','ball-from'],['steel','steal'],['steal for','steal-for'],['three','3'],['one','1'],['two','2']];


    @setProperties
      recognition:  recognition
      keywords:     keywords
      bbActions:      bbActions
      output:       output
      replacements: replacements


    window.privateVar = this

    recognition.onresult = ((event) =>
      that = window.privateVar

      resultArray= new Array()
      if (event.results.length > 0)
        for result,i in event.results[0]
          text = result.transcript
          resultArray[i] = text
        @filter(resultArray)
    )
    recognition.onstart = ->
    recognition.onstop  = ->
    recognition.onend   = -> 
      that = window.privateVar
      that.toggleProperty('isListening')


    Ember.run.scheduleOnce('afterRender', this, () ->
      $('.dropdown-button').dropdown(
        inDuration: 300
        outDuration: 225
        constrain_width: true
        hover: false
        gutter: 0
        belowOrigin: true
     ))


  filter: (results) ->
    f1r = @firstFilter(results)
    console.log(f1r)
    @setProperties
      resultString: f1r
      showResult: true

    f2r = @secondFilter(f1r)
    console.log(f2r)

  firstFilter: (results) ->
    scores = new Array()
    for result,i in results
      for keyword in @get('keywords')
        regexStr = new RegExp(keyword,"g")
        count = (result.toLowerCase().match(regexStr) || []).length
        if (typeof scores[i] == 'undefined')
          scores[i] = 0
        scores[i] += count

    matchedIndex = scores.indexOf(Math.max.apply(Math,scores))
    return results[matchedIndex].toLowerCase()

  secondFilter: (f1r) ->
    for replacement in @get('replacements')
      if (f1r.indexOf(replacement[0]) > -1)
        f1r = replaceAll(replacement[0],replacement[1],f1r);
    parsedResults = f1r.split(' ')
    output = @get('output')
    for parsedResult in parsedResults
      if parsedResult.toString().includes('#')
        output.push(parsedResult) 
      if parsedResult.toString().includes('1st')
        output.push(parsedResult) 
      if parsedResult.toString().includes('2nd')
        output.push(parsedResult) 
      if parsedResult.toString().includes('rebound')
        output.push(parsedResult) 
      if parsedResult.toString().includes('inbound')
        output.push(parsedResult) 
      if parsedResult.toString().includes('bounce')
        output.push(parsedResult) 
      if parsedResult.toString().includes('make')
        output.push(parsedResult) 
      if parsedResult.toString().includes('take')
        output.push(parsedResult) 
      if parsedResult.toString().includes('miss')
        output.push(parsedResult) 
      if parsedResult.toString().includes('grab')
        output.push(parsedResult) 
      if parsedResult.toString().includes('lose')
        output.push(parsedResult) 
      if parsedResult.toString().includes('pass')
        output.push(parsedResult) 
      if parsedResult.toString().includes('shoot')
        output.push(parsedResult) 
      if parsedResult.toString().includes('turnover-on')
        output.push(parsedResult) 
      if parsedResult.toString().includes('free-throw')
        output.push(parsedResult) 
      if parsedResult.toString().includes('no-basket-for')
        output.push(parsedResult) 
      if parsedResult.toString().includes('foul-by')
        output.push(parsedResult) 
      if parsedResult.toString().includes('foul-on') 
        output.push(parsedResult) 
      if parsedResult.toString().includes('ball-to')
        output.push(parsedResult) 
      if parsedResult.toString().includes('ball-from')
        output.push(parsedResult) 
      if parsedResult.toString().includes('steal-for')
        output.push(parsedResult) 
      if @isNumber(parsedResult.toString())
        output.push(parsedResult) 
    return output

  replaceAll: (find, replace, str) ->
    return str.replace(new RegExp(find, 'g'), replace)

  isNumber: (n) ->
        return !isNaN(parseFloat(n)) && isFinite(n)

  actions:
    scriptClick: ->
      @toggleProperty('showScript')
    startListening: ->
      recognition = @get('recognition')
      status = @get('isListening')
      @toggleProperty('isListening')

      if !status
        recognition.start()
      else
        recognition.stop()


`export default SplashController`
