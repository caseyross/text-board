Template.thread.helpers
    posts: -> Posts.find()
    
Template.thread.events
    'mouseenter .backlink': (event) ->
        togglePostOverlay 'right'
    'mouseleave .backlink': (event) ->
        togglePostOverlay off
    'mouseenter .forelink': (event) ->
        togglePostOverlay 'left'
    'mouseleave .forelink': (event) ->
        togglePostOverlay off
    'mouseenter .reply': (event) ->
        saveSelection()
    'click .reply': (event) ->
        # Show post input if it's not already visible
        bottom = document.getElementById('newPost').getBoundingClientRect().bottom
        if bottom > window.innerHeight
            toggleFloatPanel on
        document.getElementById('comment').focus()
        # Insert markup for a reply
        # Save reply content and cursor position in session storage
        backlink = '>>'
        backlink += @number
        backlink += '\n'
        comment = Session.get 'comment'
        pos = Session.get 'comment_pos'
        newComment = comment[0...pos] + backlink + quotedSelection() + comment[pos..]
        Session.set 'comment', newComment
        newPos = pos + backlink.length
        Session.set 'comment_pos', newPos
    'click #cancelFloating': (event) ->
        toggleFloatPanel off
        Session.set 'comment', ''

selection = ''

saveSelection = ->
    selection = window.getSelection().toString()
    
quotedSelection = ->
    if selection
        return selection.replace(/^/mg, '$&> ')
    else
        return ''
        
togglePostOverlay = (state) =>
    overlay = document.getElementById('postOverlay')
    if state == off
        overlay.classList.add 'absent'
        Session.set 'post_overlay', undefined
    else
        originalPostNumber = event.target.hash[1..]
        Session.set 'post_overlay', originalPostNumber
        originalPost = document.getElementById(originalPostNumber)
        switch state
            when 'right'
                top = event.target.offsetTop + event.target.offsetHeight // 2 - originalPost.offsetHeight // 2
                left = event.target.offsetLeft + 10 * event.target.innerText.length + 2
                top = 0 if top < 0
                overlay.style.top = top + 'px'
                overlay.style.left = left + 'px'
                overlay.style.right = ''
            when 'left'
                top = event.target.offsetTop + event.target.offsetHeight // 2 - originalPost.offsetHeight // 2
                right = document.body.offsetWidth - event.fromElement.offsetLeft + 8
                top = 0 if top < 0
                overlay.style.top = top + 'px'
                overlay.style.right = right + 'px'
                overlay.style.left = ''
        overlay.classList.remove 'absent'

toggleReplyHint = (state, number) ->
    if state
        document.getElementById('rh' + number).classList.remove 'invisible'
    else
        document.getElementById('rh' + number).classList.add 'invisible'
        
        
@toggleFloatPanel = (state) ->
    if state
        document.getElementById('newPost').classList.add 'floating'
        document.getElementById('newPostSpacer').classList.remove 'absent'
        document.getElementById('cancelFloating').classList.remove 'absent'
    else
        document.getElementById('newPost').classList.remove 'floating'
        document.getElementById('newPostSpacer').classList.add 'absent'
        document.getElementById('cancelFloating').classList.add 'absent'