Session.setDefault 'postInput', ''

Template.newpost.helpers
  postInput: ->
    Session.get 'postInput'

Template.newpost.events
  'input textarea': (event) ->
    content = event.target.value
    Session.set 'postInput', content
  'submit form': (event) ->
    event.preventDefault()
    content = event.target.content.value
    Meteor.call 'postReply', FlowRouter.getParam('_id'), content, (error, result) ->
      if result
        Session.set 'postInput', ''
    event.target.content.value = ""
  # TODO: Figure out why this is not detected
  'popstate': (event) ->
    Session.set 'postInput', ''