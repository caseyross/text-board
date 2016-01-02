Meteor.methods

    postThread: (title, comment, image_id) ->
        title = title.trim()
        comment = comment.trim()
        if title.length > 0 and comment.length > 0
            tid = Threads.insert
                title: title
                postCount: 1
                timestamp: +moment()
            Posts.insert
                _tid: tid
                number: 1
                comment: comment
                image: image_id
                timestamp: +moment()
                replies: []
            return tid
        else
            throw new Meteor.Error 'incomplete-form'

    reply: (tid, comment, image_id) ->
        comment = comment.trim()
        if comment.length > 0 or image_id?
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
            repliedTo = comment.match replyRegex
            # Insert new post
            id = Posts.insert
                _tid: tid
                number: number
                comment: comment
                image: image_id
                timestamp: +moment()
                replies: []
            # Mark replies to previous posts
            if repliedTo?
                markReplies(tid, number, repliedTo, id)
            return id
        else
            throw new Meteor.Error 'incomplete-form'

markReplies = (tid, number, repliedTo, id) ->
    repliedTo = repliedTo.map (x) -> parseInt(x.slice(2), 10)
    repliedTo = repliedTo.filter (x) -> 0 < x < number
    repliedTo = _.uniq(repliedTo)
    for numberRepliedTo in repliedTo
        Posts.update( {_tid: tid, number: numberRepliedTo}, {$push: {replies: number}} )