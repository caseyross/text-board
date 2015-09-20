Template.newpost.events
  'submit form': (event) ->
    event.preventDefault()
    content = event.target.content.value
    tid = Session.get 'tid'
    Meteor.call('postReply', tid, content)
    event.target.content.value = ""