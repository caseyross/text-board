Meteor.methods

    postThread: (name, content) ->
        name = name.trim()
        content = content.trim()
        if name.length > 0 and content.length > 0
            tid = Threads.insert
                name: name
                postCount: 1
                timestamp: +moment()
            Posts.insert
                _tid: tid
                number: 1
                content: content
                timestamp: +moment()
                replies: []
                replyIds: []
            return tid
        else
            throw new Meteor.Error 'incomplete-form'

    postReply: (tid, content) ->
        content = content.trim()
        if content.length > 0
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
                timestamp: +moment()
                replies: []
                replyIds: []
            # Mark replies to previous posts
            if repliedTo?
                Meteor.call('insertReplies', tid, number, repliedTo, id)
            return true
        else
            throw new Meteor.Error 'incomplete-form'

    insertReplies: (tid, number, repliedTo, id) ->
        repliedTo = repliedTo.map (x) -> parseInt(x.slice(2), 10)
        repliedTo = repliedTo.filter (x) -> 0 < x < number
        repliedTo = _.uniq(repliedTo)
        for numberRepliedTo in repliedTo
            Posts.update( {_tid: tid, number: numberRepliedTo}, {$push: {replies: number}} )