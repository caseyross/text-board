Template.newthread.events
  'submit form': (event) ->
    event.preventDefault()
    name = event.target.name.value
    content = event.target.content.value
    Meteor.call 'postThread', name, content, (error, result) ->
      if result
        Session.set 'tid', result
        Session.set 'addthread', false
        Session.set 'tselected', true