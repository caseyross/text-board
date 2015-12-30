Session.setDefault 'comment', ''
Session.setDefault 'comment_pos', 0

Template.new_post.helpers
    comment: ->
        Session.get 'comment'

Template.new_post.events
    'input #comment': (event) ->
        Session.set 'comment', event.target.value
        Session.set 'comment_pos', event.target.selectionStart
    'click #comment': (event) ->
        Session.set 'comment_pos', event.target.selectionStart
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
            reply(comment, undefined)
            
@reply = (comment, image_id) ->
    # Theoretically the user could set parameters to whatever but I don't see a problem
    Meteor.call 'reply', FlowRouter.getParam('_id'), comment, image_id, (error, result) ->
        if result
            toggleFloatPanel off
            Session.set 'comment', ''
            document.getElementById('file').value = ""
        else
            console.log error
            # TODO: tell users about error
        setPostSubmitBtn 'ready'
            
@setPostSubmitBtn = (state) ->
    btn = document.getElementById('submitPost')
    switch state
        when 'ready'
            btn.disabled = false
            btn.value = 'Submit'
        when 'uploading'
            btn.disabled = true
            btn.value = 'Uploading...'