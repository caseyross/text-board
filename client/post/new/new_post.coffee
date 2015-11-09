Session.setDefault 'postInput', ''
Session.setDefault 'postInputCursorPos', 0

Template.new_post.helpers
    postInput: ->
        Session.get 'postInput'

Template.new_post.events
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
                toggleFloatPanel off
                Session.set 'postInput', ''
                event.target.content.value = ""
            else
                console.log error
                # TODO: tell users about error