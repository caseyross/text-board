Meteor.methods

    submitPost: (tid, comment, image_id) ->
        ip_address = @connection.clientAddress
        comment = comment.trim()
        if comment.length > 0 or image_id?
            addPost(tid, comment, image_id, ip_address)
        else
            throw new Meteor.Error 'incomplete-form'

    submitThread: (title, comment, image_id) ->
        ip_address = @connection.clientAddress
        title = title.trim()
        comment = comment.trim()
        if title.length > 0 and comment.length > 0
            addThread(title, comment, image_id, ip_address)
        else
            throw new Meteor.Error 'incomplete-form'

addThread = (title, comment, image_id, ip_address) ->
    timestamp = +moment()
    tid = Threads.insert
        title: title
        postCount: 1
        created: timestamp
        modified: timestamp
    # Insert title post
    Posts.insert
        _tid: tid
        number: 0
        special: 'title'
        comment: title
        image: null
        timestamp: timestamp
        replies: null
    # Insert first post
    Posts.insert
        _tid: tid
        number: 1
        special: null
        comment: comment
        image: image_id
        timestamp: timestamp
        replies: []
        ip_address: ip_address
    return tid
    
addPost = (tid, comment, image_id, ip_address) ->
    timestamp = +moment()
    # Increase post count and set time of modification
    thread = Threads.findAndModify
        query:
            _id: tid
        update:
            $inc:
                postCount: 1
            $set:
                modified: timestamp
    number = thread.postCount + 1
    # Check for need to make a new date post (TODO: how does this work with time zones?)
    if moment(thread.modified).date() != moment(timestamp).date()
        Posts.insert
            _tid: tid
            number: number - 0.5
            special: 'date'
            comment: moment(thread.modified).format 'dddd, MMMM Do, YYYY'
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
        ip_address: ip_address
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