Template.thread.helpers
    posts: -> Posts.find(_tid: FlowRouter.getParam '_id' )
    
Template.thread.events
    'click .post-reply-btn': (event) ->
        toggleFloatPanel on
        document.getElementById('postInput').focus()
        replyLink = '>>'
        replyLink += this.number
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
        
@toggleFloatPanel = (status) ->
    if status
        document.getElementById('newPostPanel').classList.add 'floating'
        document.getElementById('newPostPanelSpacer').classList.remove 'hidden'
        document.getElementById('cancelFloatingBtn').classList.remove 'hidden'
    else
        document.getElementById('newPostPanel').classList.remove 'floating'
        document.getElementById('newPostPanelSpacer').classList.add 'hidden'
        document.getElementById('cancelFloatingBtn').classList.add 'hidden'