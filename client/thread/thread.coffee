Template.thread.helpers
    posts: -> Posts.find({})
    
Template.thread.events
    'mouseenter .backlink': (event) ->
        togglePostOverlay 'right'
    'mouseleave .backlink': (event) ->
        togglePostOverlay off
    'mouseenter .forelink': (event) ->
        togglePostOverlay 'left'
    'mouseleave .forelink': (event) ->
        togglePostOverlay off
    'focus .post-reply-btn': (event) ->
        #toggleReplyHint on, @number
        saveSelection()
    'blur .post-reply-btn': (event) ->
        #toggleReplyHint off, @number
    'mouseenter .post-header': (event) ->
        toggleReplyHint on, @number
        saveSelection()
    'mouseleave .post-header': (event) ->
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
        
@togglePostOverlay = (status) =>
    switch status
        when 'right'
            originalPostNumber = event.target.hash[1..]
            Session.set 'post_overlay', originalPostNumber
            originalPost = document.getElementById(originalPostNumber)
            overlay = document.getElementById('postOverlay')
            overlay.style.top = (event.pageY - event.offsetY + event.target.offsetTop - originalPost.offsetHeight // 2 + event.target.offsetHeight // 2) + 'px'
            overlay.style.left = (event.pageX - event.offsetX + event.target.offsetLeft - 26 + 9 * event.target.hash.length) + 'px'
            # TODO: Maybe we can remove some of these magic numbers
        when 'left'
            originalPostNumber = event.target.hash[1..]
            Session.set 'post_overlay', originalPostNumber
            originalPost = document.getElementById(originalPostNumber)
            overlay = document.getElementById('postOverlay')
            overlay.style.top = (event.pageY - event.offsetY - originalPost.offsetHeight // 2 + event.target.offsetHeight // 2) + 'px'
            overlay.style.left = (event.pageX - event.offsetX - originalPost.offsetWidth - 8) + 'px'
        else
            Session.set 'post_overlay', undefined

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