Session.setDefault 'comment', ''
Session.setDefault 'comment_pos', 0

Template.new_post.helpers
    comment: ->
        Session.get 'comment'

Template.new_post.events
    'input #comment': (event) ->
        textarea = event.target
        comment = textarea.value
        document.getElementById('commentMirror').innerHTML = comment
        window.scrollTo(window.scrollX, document.body.scrollHeight) # TODO: don't scroll when floating
        validate()
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
            label.innerHTML = '➕'
        validate()
    'submit form': (event) ->
        event.preventDefault()
        comment = event.target.comment.value
        files = event.target.file.files
        if files.length > 0
            setPostSubmitBtn 'uploading'
            # Possibly extendable to multiple images
            image = {
                id: Random.id()
            }
            # TODO: Review upload flow and hopefully flatten callbacks
            img = new Image()
            fr = new FileReader()
            fr.readAsDataURL(files[0])
            fr.onload = (event) ->
                img.src = fr.result
                img.onload = () ->
                    image.name = files[0].name
                    image.size = files[0].size
                    image.height = img.height
                    image.width = img.width
                    Cloudinary.upload(
                        files,
                        public_id: image.id,
                        (error, result) ->
                            if result
                                reply(comment, image)
                            else
                                # TODO: provide error feedback
                                console.log error
                                validate()
                    )
            fr.onerror = (event) ->
                console.log fr.error
                validate()
        else
            reply(comment, null)
            validate()
            
validate = () ->
    wroteComment = document.getElementById('comment').value.length > 0
    choseFile = document.getElementById('file').files.length > 0
    if wroteComment || choseFile
        setPostSubmitBtn 'ready'
    else
        setPostSubmitBtn 'locked'
            
setPostSubmitBtn = (state) ->
    btn = document.getElementById('submitPost')
    switch state
        when 'locked'
            btn.disabled = true
            btn.value = 'Submit'
        when 'ready'
            btn.disabled = false
            btn.value = 'Submit'
        when 'uploading'
            btn.disabled = true
            btn.value = 'Uploading...'
            
reply = (comment, image) ->
    Meteor.call 'submitPost', FlowRouter.getParam('_id'), comment, image, (error, result) ->
        if result
            toggleFloatPanel off
            Session.set 'comment', ''
            document.getElementById('comment').rows = 2
            document.getElementById('file').value = ''
            document.getElementById('L_file').innerHTML = '➕'
        else
            console.log error
            # TODO: tell users about error
        validate()