Template.thread.helpers
    posts: -> Posts.find(_tid: FlowRouter.getParam '_id' )
    
Template.thread.events
    'focus .post-reply-btn': (event) ->
        toggleReplyHint on, @number
    'blur .post-reply-btn': (event) ->
        toggleReplyHint off, @number
    'mouseover .post-reply-btn': (event) ->
        toggleReplyHint on, @number
    'mouseout .post-reply-btn': (event) ->
        toggleReplyHint off, @number
    'click .post-reply-btn': (event) ->
        # Show post input if it's not already visible
        newPostPanelBottom = document.getElementById('newPostPanel').getBoundingClientRect().bottom
        if newPostPanelBottom > window.innerHeight
            toggleFloatPanel on
        document.getElementById('postInput').focus()
        # Insert markup for a reply
        # Save reply content and cursor position in session storage
        replyLink = '>>'
        replyLink += @number
        replyLink += '\n'
        input = Session.get 'postInput'
        cursorPos = Session.get 'postInputCursorPos'
        input = input[0...cursorPos] + replyLink + input[cursorPos..]
        Session.set 'postInput', input
        newCursorPos = cursorPos + replyLink.length
        Session.set 'postInputCursorPos', newCursorPos
    'click .cancel-floating-btn': (event) ->
        toggleFloatPanel off
        Session.set 'postInput', ''
        
@toggleReplyHint = (status, number) ->
    if status
        document.getElementById('rh' + number).classList.remove 'invisible'
    else
        document.getElementById('rh' + number).classList.add 'invisible'
        
        
@toggleFloatPanel = (status) ->
    if status
        document.getElementById('newPostPanel').classList.add 'floating'
        document.getElementById('newPostPanelSpacer').classList.add 'invisible'
        document.getElementById('newPostPanelSpacer').classList.remove 'absent'
        document.getElementById('cancelFloatingBtn').classList.remove 'absent'
    else
        document.getElementById('newPostPanel').classList.remove 'floating'
        document.getElementById('newPostPanelSpacer').classList.add 'absent'
        document.getElementById('newPostPanelSpacer').classList.remove 'invisible'
        document.getElementById('cancelFloatingBtn').classList.add 'absent'