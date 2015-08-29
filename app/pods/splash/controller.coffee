`import Ember from 'ember'`

SplashController = Ember.Controller.extend
  showScript:	      false
  isListening:      false
  showResult:       false
  detectedActions:  []
  recognition:      undefined
  currentIndex:	    undefined
  lastID:           undefined
  lastID_i:   	    undefined
  currentElement:   undefined
  structuredData:   undefined

  showTable: Ember.computed 'structuredData', ->
    Ember.isPresent @get('structuredData')

  init: ->
    @_super()

    #For Testing purposes
     
    #data = [
      #['Item 1','-','#24-blue','pass','ball-to','#10-blue']
      #['Item 2','23567681','#3-red','make','2']
    #]
    #actions = ['make','shoot','rebound']
    #resultTxt = 'Lorem ipsum dolor sit amet, eu has graece adolescens efficiendi'
    #@set('structuredData', data)
    #@set('detectedActions', actions)
    #@set('resultString', resultTxt)

    recognition = new webkitSpeechRecognition()

    recognition.maxAlternatives = 10

    keywords = ['shoot', 'make', 'inbound','bounce', 'lose', 'steal', 'pass', 'foul', 'free throw', 'miss', 'rebound', 'turnover', 'blue', 'red']
    bbActions = ['make','miss','grab','pass','lose','shoot','turnover-on','take','foul-by','foul-on','no-basket-for','steal-for','inbound','bounce']
    output = new Array()
    replacements = [['number ', '#', ],['makes','make'],['first','1st'],['second','2nd'],['free throw','free-throw'],['mrs.','miss'],['misses','miss'],['crabs','grab'],['grabs','grab'],['passes','pass'],['passed','pass'],['shoots','shoot'],['bounces','bounce'],['inbounds','inbound'],['loses','lose'],['ride','red'],['read','red'],[' red','-red'],['lou', 'blue'],[' blue','-blue'],['turn over','turnover'],['turnover on','turnover-on'],['ii','2nd'],['takes','take'],['fouled','foul'],['foul by','foul-by'],['foul on','foul-on'],['no basket for','no-basket-for'],['ball to','ball-to'],['ball from','ball-from'],['steel','steal'],['steal for','steal-for'],['three','3'],['one','1'],['two','2']]


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

    @set('detectedActions', [])

    f1r = @firstFilter(results)
    console.log(f1r)

    f2r = @secondFilter(f1r)
    console.log(f2r)

    f3r = @thirdFilter(f2r)
    console.log(f3r)
    console.log @get('detectedActions')
    @set('structuredData', f3r)

    @setProperties
      resultString: f1r
      showResult: true

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
        f1r = @replaceAll(replacement[0],replacement[1],f1r)
        console.log f1r

    parsedResults = f1r.split(" ")
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

  thirdFilter: (f2r) ->
    finalResults_i = 0
    @set('currentIndex', 0)
    finalResults = new Array()
    currentIndex = @get('currentIndex')
    while currentIndex < (f2r.length - 1)
      currentElement = @getNextElement(f2r, currentIndex)
      if currentElement.indexOf('#') > -1
        @set('lastID', currentElement)
        @set('lastID_i', currentIndex)
        currentIndex++
        currentElement = @getNextElement(f2r, currentIndex)
      if @isAction(currentElement)
        actions = @get('detectedActions')
        actions.pushObject(currentElement)
        @set('detectedActions', actions)
        type = @getActionParamsType(currentElement)
        console.log(currentElement)
        console.log(type)
        finalResults[finalResults_i] = @getContext(f2r, @get('lastID_i'),currentIndex, type)
        finalResults[finalResults_i].unshift("Item #{finalResults_i + 1}", "-")
        console.log(finalResults_i)
        finalResults_i++
      currentIndex++
    return finalResults

  getNextElement: (elements, i) ->
    elements[i]

  isAction: (element) ->
    if @get('bbActions').indexOf(element) > -1
      true
    else
      false

  isID: (element) ->
    if element.indexOf('#') > -1
      true
    else
      false

  getActionParamsType: (element) ->
    beforeType = ['make','miss','grab','shoot','take']
    afterType = ['turnover-on','foul-on','foul-by','no-basket-for','steal-for']
    bothType = ['lose','pass','inbound','bounce']
    if beforeType.indexOf(element) > -1
      return "before"
    else if afterType.indexOf(element) > -1
      "after"
    else if bothType.indexOf(element) > -1
      "both"

  getContext: (arr,ID_i, current_i,type) ->
    context = []
    contextComplete = false
    if type == "before"
      context.push(arr[ID_i])
      while (!contextComplete)
        context.push(arr[current_i++])
        if typeof (arr[current_i]) == 'undefined'
          console.log typeof(arr[current_i])
          currentIndex = current_i - 1
          contextComplete = true
          break
        if @isAction(arr[current_i]) || @isID(arr[current_i])
          currentIndex = current_i
          contextComplete = true
    else if type == "after"
      while (!contextComplete)
        context.push(arr[current_i++])
        if (typeof (arr[current_i]) == 'undefined')
          console.log(typeof (arr[current_i]))
          currentIndex = current_i - 1
          contextComplete = true
          break
        if (@isID(arr[current_i]))
          context.push(arr[current_i])
          currentIndex = current_i
          contextComplete = true
        else if (@isAction(arr[current_i]))
          currentIndex = current_i
          contextComplete = true
    else if (type == "both")
      context.push(arr[ID_i])
      while (!contextComplete)
        context.push(arr[current_i++])
        if (typeof (arr[current_i]) == 'undefined')
          console.log(typeof (arr[current_i]))
          currentIndex = current_i - 1
          contextComplete = true
          break
        if (@isID(arr[current_i]))
          context.push(arr[current_i])
          currentIndex = current_i
          contextComplete = true
    return context

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
