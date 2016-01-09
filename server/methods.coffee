Meteor.methods

    submitPost: (tid, comment, image_id) ->
        comment = comment.trim()
        if comment.length > 0 or image_id?
            addPost(tid, comment, image_id)
        else
            throw new Meteor.Error 'incomplete-form'

    submitThread: (title, comment, image_id) ->
        title = title.trim()
        comment = comment.trim()
        if title.length > 0 and comment.length > 0
            addThread(title, comment, image_id)
        else
            throw new Meteor.Error 'incomplete-form'

addThread = (title, comment, image_id) ->
    timestamp = +moment()
    tid = Threads.insert
        title: title
        postCount: 1
        created: timestamp
        modified: timestamp
    Posts.insert
        _tid: tid
        number: 0
        special: 'title'
        comment: title
        image: null
        timestamp: timestamp
        replies: null
    Posts.insert
        _tid: tid
        number: 1
        special: null
        comment: comment
        image: image_id
        timestamp: timestamp
        replies: []
    return tid
    
addPost = (tid, comment, image_id) ->
    timestamp = +moment()
    # Increase post count
    thread = Threads.findAndModify
        query:
            _id: tid
        update:
            $inc:
                postCount: 1
            $set:
                modified: timestamp
    number = thread.postCount + 1
    if moment(thread.modified).hour() != moment(timestamp).hour()
        Posts.insert
            _tid: tid
            number: number - 0.5
            special: 'date'
            comment: moment(thread.modified).format 'dddd, MMMM Do, YYYY - h:mm A'
            image: null
            timestamp: timestamp
            replies: null
    # Check for replies in post
    replyRegex = new RegExp(/>>\d+/g)
    repliedTo = comment.match replyRegex
    # Insert new post
    id = Posts.insert
        _tid: tid
        number: number
        special: null
        comment: comment
        image: image_id
        timestamp: timestamp
        replies: []
    # Mark replies to previous posts
    if repliedTo?
        markReplies(tid, number, repliedTo, id)
    return id

markReplies = (tid, number, repliedTo, id) ->
    repliedTo = repliedTo.map (x) -> parseInt(x.slice(2), 10)
    repliedTo = repliedTo.filter (x) -> 0 < x < number
    repliedTo = _.uniq(repliedTo)
    for numberRepliedTo in repliedTo
        Posts.update( {_tid: tid, number: numberRepliedTo}, {$push: {replies: number}} )