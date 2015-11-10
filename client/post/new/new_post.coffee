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
            # Possibly extendable to multiple images
            image_id = Random.id()
            image = new Image()
            image.onload = (event) ->
                image_width = image.width
                postReply(content, image_id, image_width)
                window.URL.revokeObjectURL(@src)
            image.src = window.URL.createObjectURL(files[0])
            Cloudinary.upload(
                files,
                public_id: image_id,
                (error, result) ->
                    if result
                        console.log result
                    else
                        console.log error
            )
        else
            postReply(content, '', 0)
            
@postReply = (content, image_id, image_width) ->
    # Theoretically the user could set parameters to whatever but I don't see a problem
    Meteor.call 'postReply', FlowRouter.getParam('_id'), content, image_id, image_width, (error, result) ->
        if result
            toggleFloatPanel off
            Session.set 'postInput', ''
            document.getElementById('postInput').value = ""
        else
            console.log error
            # TODO: tell users about error