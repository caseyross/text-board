Template.thread.helpers
    posts: -> Posts.find(_tid: FlowRouter.getParam '_id' )
    
Template.thread.events
    'click .post-reply-btn': (event) ->
        newPostPanelBottom = document.getElementById('newPostPanel').getBoundingClientRect().bottom
        if newPostPanelBottom > window.innerHeight
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
        document.getElementById('newPostPanelSpacer').classList.add 'invisible'
        document.getElementById('newPostPanelSpacer').classList.remove 'absent'
        document.getElementById('cancelFloatingBtn').classList.remove 'absent'
    else
        document.getElementById('newPostPanel').classList.remove 'floating'
        document.getElementById('newPostPanelSpacer').classList.add 'absent'
        document.getElementById('newPostPanelSpacer').classList.remove 'invisible'
        document.getElementById('cancelFloatingBtn').classList.add 'absent'