`import DS from 'ember-data'`

ApplicationAdapter = DS.RESTAdapter.extend
  host: 'http://localhost:4500'
  namespace: 'api'

`export default ApplicationAdapter`
