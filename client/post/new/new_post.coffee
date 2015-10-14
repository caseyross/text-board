Session.setDefault 'postInput', ''
Session.setDefault 'postInputCursorPos', 0

Template.newpost.helpers
  postInput: ->
    Session.get 'postInput'

Template.newpost.events
  'input textarea': (event) ->
    content = event.target.value
    Session.set 'postInput', content
    Session.set 'postInputCursorPos', event.target.selectionStart
  'click textarea': (event) ->
    Session.set 'postInputCursorPos', event.target.selectionStart
  'submit form': (event) ->
    event.preventDefault()
    content = event.target.content.value
    Meteor.call 'postReply', FlowRouter.getParam('_id'), content, (error, result) ->
      if result
        Session.set 'postInput', ''
    event.target.content.value = ""