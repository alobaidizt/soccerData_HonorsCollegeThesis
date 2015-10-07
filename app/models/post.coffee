`import DS from 'ember-data'`

Post =  DS.Model.extend
  name:     DS.attr('String')
  date:     DS.attr('Date')
  creator:  DS.attr('String')
  content:  DS.attr('String')

`export default Post`
