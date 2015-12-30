Meteor.methods

    postThread: (title, content, image_id) ->
        title = title.trim()
        content = content.trim()
        if title.length > 0 and content.length > 0
            tid = Threads.insert
                title: title
                postCount: 1
                timestamp: +moment()
            Posts.insert
                _tid: tid
                number: 1
                content: content
                image: image_id
                image_status: 'uploaded'
                timestamp: +moment()
                replies: []
                replyIds: []
            return tid
        else
            throw new Meteor.Error 'incomplete-form'

    reply: (tid, content, image_id) ->
        content = content.trim()
        if content.length > 0 or image_id?
            # Increase post count
            thread = Threads.findAndModify
                query:
                    _id: tid
                update:
                    $inc:
                        postCount: 1
                new: true
            number = thread.postCount
            # Check for replies in post
            replyRegex = new RegExp(/>>\d+/g)
            repliedTo = content.match replyRegex
            # Insert new post
            id = Posts.insert
                _tid: tid
                number: number
                content: content
                image: image_id
                image_status: 'uploaded'
                timestamp: +moment()
                replies: []
                replyIds: []
            # Mark replies to previous posts
            if repliedTo?
                Meteor.call('insertReplies', tid, number, repliedTo, id)
            return id
        else
            throw new Meteor.Error 'incomplete-form'

    insertReplies: (tid, number, repliedTo, id) ->
        repliedTo = repliedTo.map (x) -> parseInt(x.slice(2), 10)
        repliedTo = repliedTo.filter (x) -> 0 < x < number
        repliedTo = _.uniq(repliedTo)
        for numberRepliedTo in repliedTo
            Posts.update( {_tid: tid, number: numberRepliedTo}, {$push: {replies: number}} )
            
    updateImageStatus: (id, newStatus) ->
        Posts.update( {_id: id}, {$set: {image_status: newStatus}} )