`import DS from 'ember-data'`

Note = DS.Model.extend
  title: DS.attr('string')
  content: DS.attr('string')
  author: DS.attr('string')


`export default Note`
