Template.newpost.events
  'submit form': (event) ->
    event.preventDefault()
    content = event.target.content.value
    Meteor.call('postReply', _id, content)
    event.target.content.value = ""