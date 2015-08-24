`import { moduleFor, test } from 'ember-qunit'`

moduleFor 'route:splash5', 'Unit | Route | splash5', {
  # Specify the other units that are required for this test.
  # needs: ['controller:foo']
}

test 'it exists', (assert) ->
  route = @subject()
  assert.ok route
