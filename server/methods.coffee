Meteor.methods

    submitPost: (tid, comment, image) ->
        
        #-- tid
        # HAS CORRECT TYPE
        check tid, String
        # CORRECT LENGTH
        check tid, Match.Where (x) ->
            x.length == 17
        
        #-- comment
        # HAS CORRECT TYPE
        check comment, String
        # NOT EMPTY
        comment = comment.trim()
        check comment, Match.Where (x) ->
            x.length > 0
        # NOT TOO LONG
        check comment, Match.Where (x) ->
            x.length < 65536
        
        #-- image
        # HAS CORRECT TYPE
        if image?
            check image, {
                id, String
                name, String
                size, Number
                height, Number
                width, Number
            }
        # TODO: validate all fields
        
        ip_address = @connection.clientAddress
        addPost(tid, comment, image, ip_address)

    submitThread: (title, comment, image) ->
        
        #-- title
        # HAS CORRECT TYPE
        check title, String
        # NOT EMPTY
        title = title.trim()
        check title, Match.Where (x) ->
            x.length > 0
        # NOT TOO LONG
        check comment, Match.Where (x) ->
            x.length < 64
        
        #-- comment
        # HAS CORRECT TYPE
        check comment, String
        # NOT EMPTY
        comment = comment.trim()
        check comment, Match.Where (x) ->
            x.length > 0
        # NOT TOO LONG
        check comment, Match.Where (x) ->
            x.length < 65536
        
        #-- image
        # HAS CORRECT TYPE
        if image?
            check image, {
                id, String
                name, String
                size, Number
                height, Number
                width, Number
            }
        # TODO: validate all fields
        
        ip_address = @connection.clientAddress
        addThread(title, comment, image, ip_address)

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