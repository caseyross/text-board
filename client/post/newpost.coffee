Template.newpost.events
  'submit form': (event) ->
    event.preventDefault()
    content = event.target.content.value
    Meteor.call('postReply', FlowRouter.getParam('_id'), content)
    event.target.content.value = ""