`import DS from "ember-data"`

ApplicationAdapter = DS.RESTAdapter.extend
    host: 'https://127.0.0.1:444'
    namespace: 'api'

`export default ApplicationAdapter`
