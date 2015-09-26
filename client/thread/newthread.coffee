Template.newthread.events
  'submit form': (event) ->
    event.preventDefault()
    name = event.target.name.value
    content = event.target.content.value
    Meteor.call 'postThread', name, content, (error, result) ->
      if result
        FlowRouter.go('/#{result}')