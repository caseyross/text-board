Session.setDefault 'postInput', ''
Session.setDefault 'postInputCursorPos', 0

Template.new_post.helpers
    postInput: ->
        Session.get 'postInput'

Template.new_post.events
    'input textarea': (event) ->
        content = event.target.value
        Session.set 'postInput', content
        Session.set 'postInputCursorPos', event.target.selectionStart
    'click textarea': (event) ->
        Session.set 'postInputCursorPos', event.target.selectionStart
    'submit form': (event) ->
        event.preventDefault()
        content = event.target.textInput.value
        files = event.target.fileInput.files
        if files.length > 0
            setPostSubmitBtn 'uploading'
            # Possibly extendable to multiple images
            image_id = Random.id()
            Cloudinary.upload(
                files,
                public_id: image_id,
                (error, result) ->
                    if result
                        postReply(content, image_id)
                    else
                        # TODO: provide error feedback
                        console.log error
                        setPostSubmitBtn 'ready'
            )
        else
            postReply(content, undefined)
            
@postReply = (content, image_id) ->
    # Theoretically the user could set parameters to whatever but I don't see a problem
    Meteor.call 'postReply', FlowRouter.getParam('_id'), content, image_id, (error, result) ->
        if result
            toggleFloatPanel off
            Session.set 'postInput', ''
            document.getElementById('postInput').value = ""
            document.getElementById('postFileInput').value = ""
        else
            console.log error
            # TODO: tell users about error
        setPostSubmitBtn 'ready'
            
@setPostSubmitBtn = (state) ->
    postSubmitBtn = document.getElementById('postSubmitBtn')
    switch state
        when 'ready'
            postSubmitBtn.disabled = false
            postSubmitBtn.value = 'Submit'
        when 'uploading'
            postSubmitBtn.disabled = true
            postSubmitBtn.value = 'Uploading...'