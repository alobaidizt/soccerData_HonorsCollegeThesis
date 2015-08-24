`import DS from 'ember-data'`

ApplicationSerializer = DS.RESTSerializer.extend
  primaryKey: '_id'
  serializeId: (id) => id.toString()

`export default ApplicationSerializer`
