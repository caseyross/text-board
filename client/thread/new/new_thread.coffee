Template.new_thread.events
    'input #firstPost': (event) ->
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
    'change #file': (event) ->
        fileName = event.target.value.split('\\').pop()
        label = document.getElementById('L_file')
        if fileName
            label.innerHTML = fileName
        else
            label.innerHTML = 'Choose file'
    'submit form': (event) ->
        event.preventDefault()
        title = event.target.title.value
        firstPost = event.target.firstPost.value
        files = event.target.file.files
        if files.length > 0
            setThreadSubmitBtn 'uploading'
            # Possibly extendable to multiple images
            image_id = Random.id()
            Cloudinary.upload(
                files,
                public_id: image_id,
                (error, result) ->
                    if result
                        postThread(title, firstPost, image_id)
                    else
                        # TODO: provide error feedback
                        console.log error
                        setThreadSubmitBtn 'ready'
            )
        else
            postThread(title, firstPost, '')
            
@postThread = (title, firstPost, image_id) ->
    Meteor.call 'postThread', title, firstPost, image_id, (error, result) ->
        if result
            newPath = '/t/' + result
            FlowRouter.go(newPath)
        else
            console.log error
            # TODO: tell users about error
            setThreadSubmitBtn 'ready'
            
@setThreadSubmitBtn = (state) ->
    btn = document.getElementById('submitThread')
    switch state
        when 'ready'
            btn.disabled = false
            btn.value = 'Submit'
        when 'uploading'
            btn.disabled = true
            btn.value = 'Uploading...'