Template.catalog.helpers
  threads: -> Threads.find()
  
Template.catalog.events
  'click li': (event) ->
    Session.set 'tselected', true
    Session.set 'tid', event.target.id
  'click .new': (event) ->
    Session.set 'addthread', true