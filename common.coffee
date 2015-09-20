Threads = new Mongo.Collection 'threads'
Posts = new Mongo.Collection 'posts'

if Meteor.isClient
  
  Meteor.subscribe 'threads'
  # TODO: only subscribe to posts in currently viewed threads
  Meteor.subscribe 'posts'
    
  Template.catalog.helpers
    threads: -> Threads.find()
  
  Template.thread.helpers
    posts: -> Posts.find(_tid: Session.get 'tid')
    
  Template.newthread.events
    'submit form': (event) ->
      event.preventDefault()
      name = event.target.name.value
      content = event.target.content.value
      Meteor.call 'postThread', name, content, (error, result) -> if result then Session.set 'tid', result
      Session.set 'addthread', false
      Session.set 'tselected', true
  
  Template.newpost.events
    'submit form': (event) ->
      event.preventDefault()
      content = event.target.content.value
      tid = Session.get 'tid'
      Meteor.call('postReply', tid, content)
      event.target.content.value = ""
        
if Meteor.isServer
  
  Meteor.publish 'threads', -> Threads.find()
  Meteor.publish 'posts', -> Posts.find()
  
  Meteor.methods
    postThread: (name, content) ->
      name = name.trim()
      if name.length > 0
        content = content.trim()
        if content.length > 0
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
        if repliedTo?
          repliedTo = repliedTo.map (x) -> parseInt(x.slice(2), 10)
          repliedTo = repliedTo.filter (x) -> 0 < x < number
          repliedTo = _.uniq(repliedTo)
          Meteor.call('insertReplies', tid, number, repliedTo, id)
    insertReplies: (tid, number, repliedTo, id) ->
      for numberRepliedTo in repliedTo
        Posts.update( {_tid: tid, number: numberRepliedTo}, {$push: {replies: number}} )