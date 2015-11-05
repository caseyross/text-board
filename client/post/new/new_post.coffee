Session.setDefault 'postInput', ''
Session.setDefault 'postInputCursorPos', 0

Template.new_post.helpers
    postInput: ->
        Session.get 'postInput'

Template.new_post.events
    'input textarea': (e) ->
        content = e.target.value
        Session.set 'postInput', content
        Session.set 'postInputCursorPos', e.target.selectionStart
    'click textarea': (e) ->
        Session.set 'postInputCursorPos', e.target.selectionStart
    'submit form': (e) ->
        e.preventDefault()
        content = e.target.content.value
        Meteor.call 'postReply', FlowRouter.getParam('_id'), content, (error, result) ->
            if result
                toggleFloatPanel off
                Session.set 'postInput', ''
            else
                console.log error
                # TODO: tell users about error
        e.target.content.value = ""