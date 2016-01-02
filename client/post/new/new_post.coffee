Session.setDefault 'comment', ''
Session.setDefault 'comment_pos', 0

Template.new_post.helpers
    comment: ->
        Session.get 'comment'

Template.new_post.events
    'input #comment': (event) ->
        textarea = event.target
        comment = textarea.value
        lines = comment.split('\n').length
        textarea.rows = lines + 1
        clientHeight = textarea.clientHeight
        scrollHeight = textarea.scrollHeight
        if clientHeight < scrollHeight
            rowHeight = clientHeight / textarea.rows
            rowsNeeded = scrollHeight // rowHeight + 1
            textarea.rows = rowsNeeded
        Session.set 'comment', comment
        Session.set 'comment_pos', textarea.selectionStart
    'click #comment': (event) ->
        Session.set 'comment_pos', event.target.selectionStart
    'change #file': (event) ->
        fileName = event.target.value.split('\\').pop()
        label = document.getElementById('L_file')
        if fileName
            label.innerHTML = fileName
        else
            label.innerHTML = 'Choose file'
    'submit form': (event) ->
        event.preventDefault()
        comment = event.target.comment.value
        files = event.target.file.files
        if files.length > 0
            setPostSubmitBtn 'uploading'
            # Possibly extendable to multiple images
            image_id = Random.id()
            # TODO: may want to eagerly create full-size version
            Cloudinary.upload(
                files,
                public_id: image_id,
                (error, result) ->
                    if result
                        reply(comment, image_id)
                    else
                        # TODO: provide error feedback
                        console.log error
                        setPostSubmitBtn 'ready'
            )
        else
            reply(comment, null)
            
reply = (comment, image_id) ->
    # Theoretically the user could set parameters to whatever but I don't see a problem
    Meteor.call 'reply', FlowRouter.getParam('_id'), comment, image_id, (error, result) ->
        if result
            toggleFloatPanel off
            Session.set 'comment', ''
            document.getElementById('comment').rows = 2
            document.getElementById('file').value = ''
            document.getElementById('L_file').innerHTML = 'Choose file'
        else
            console.log error
            # TODO: tell users about error
        setPostSubmitBtn 'ready'
            
setPostSubmitBtn = (state) ->
    btn = document.getElementById('submitPost')
    switch state
        when 'ready'
            btn.disabled = false
            btn.value = 'Submit'
        when 'uploading'
            btn.disabled = true
            btn.value = 'Uploading...'