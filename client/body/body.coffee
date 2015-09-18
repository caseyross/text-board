Template.body.helpers
  tselected: -> Session.get 'tselected'
  addthread: -> Session.get 'addthread'
  
Template.body.events
  'click .back': ->
    Session.set 'tselected', false
    Session.set 'tid', undefined
    Session.set 'addthread', false