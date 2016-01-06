Template.new_thread.events
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
            
postThread = (title, firstPost, image_id) ->
    Meteor.call 'submitThread', title, firstPost, image_id, (error, result) ->
        if result
            newPath = '/t/' + result
            FlowRouter.go(newPath)
        else
            console.log error
            # TODO: tell users about error
            setThreadSubmitBtn 'ready'
            
setThreadSubmitBtn = (state) ->
    btn = document.getElementById('submitThread')
    switch state
        when 'ready'
            btn.disabled = false
            btn.value = 'Submit'
        when 'uploading'
            btn.disabled = true
            btn.value = 'Uploading...'