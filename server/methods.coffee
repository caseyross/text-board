Meteor.methods

    submitPost: (tid, comment, image) ->
        ip_address = @connection.clientAddress
        comment = comment.trim()
        if comment.length > 0 or image?
            addPost(tid, comment, image, ip_address)
        else
            throw new Meteor.Error 'incomplete-form'

    submitThread: (title, comment, image) ->
        ip_address = @connection.clientAddress
        title = title.trim()
        comment = comment.trim()
        if title.length > 0 and comment.length > 0
            addThread(title, comment, image, ip_address)
        else
            throw new Meteor.Error 'incomplete-form'

addThread = (title, comment, image, ip_address) ->
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
        image: image
        timestamp: timestamp
        replies: []
        ip_address: ip_address
    # Update user's info
    Users.findAndModify
        query:
            ip_address: ip_address
        update:
            $inc:
                rep: 1
            $set:
                lastPosted: timestamp
        upsert: true
    return tid
    
addPost = (tid, comment, image, ip_address) ->
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
    # Check for replies in post
    replyRegex = new RegExp(/>>\d+/g)
    repliedTo = comment.match replyRegex
    # Insert new post
    id = Posts.insert
        _tid: tid
        number: number
        special: null
        comment: comment
        image: image
        timestamp: timestamp
        replies: []
        ip_address: ip_address
    # Mark replies to previous posts
    if repliedTo?
        markReplies(tid, number, repliedTo, id)
    # Update user's info
    Users.findAndModify
        query:
            ip_address: ip_address
        update:
            $inc:
                rep: 1
            $set:
                lastPosted: timestamp
        upsert: true
    return id

markReplies = (tid, number, repliedTo, id) ->
    repliedTo = repliedTo.map (x) -> parseInt(x.slice(2), 10)
    repliedTo = repliedTo.filter (x) -> 0 < x < number
    repliedTo = _.uniq(repliedTo)
    for numberRepliedTo in repliedTo
        Posts.update( {_tid: tid, number: numberRepliedTo}, {$push: {replies: number}} )