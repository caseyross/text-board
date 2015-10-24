Template.thread.helpers
    posts: -> Posts.find(_tid: FlowRouter.getParam '_id' )
    
Template.thread.events
    'focus .post-reply-btn': (event) ->
        toggleReplyHint on, @number
        saveSelection()
    'blur .post-reply-btn': (event) ->
        toggleReplyHint off, @number
    'mouseover .post-header': (event) ->
        toggleReplyHint on, @number
        saveSelection()
    'mouseout .post-header': (event) ->
        toggleReplyHint off, @number
    'click .post-header': (event) ->
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
        input = input[0...cursorPos] + replyLink + quotedSelection() + input[cursorPos..]
        Session.set 'postInput', input
        newCursorPos = cursorPos + replyLink.length
        Session.set 'postInputCursorPos', newCursorPos
    'click .cancel-floating-btn': (event) ->
        toggleFloatPanel off
        Session.set 'postInput', ''

@selection = ''

@saveSelection = ->
    @selection = window.getSelection().toString()
    
@quotedSelection = ->
    if selection
        return selection.replace(/^/mg, '$&> ')
    else
        return ''

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