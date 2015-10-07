`import DS from 'ember-data'`

Keyword = DS.Model.extend
  name: DS.attr('string')
  masks: DS.attr()

`export default Keyword`
