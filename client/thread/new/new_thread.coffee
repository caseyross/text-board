Template.new_thread.events
    'submit form': (event) ->
        event.preventDefault()
        title = event.target.titleInput.value
        firstPost = event.target.firstPostInput.value
        files = event.target.fileInput.files
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
    threadSubmitBtn = document.getElementById('threadSubmitBtn')
    switch state
        when 'ready'
            threadSubmitBtn.disabled = false
            threadSubmitBtn.value = 'Submit'
        when 'uploading'
            threadSubmitBtn.disabled = true
            threadSubmitBtn.value = 'Uploading...'