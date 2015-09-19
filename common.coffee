Threads = new Mongo.Collection 'threads'
Posts = new Mongo.Collection 'posts'

if Meteor.isClient
    
  Template.catalog.helpers
    threads: -> Threads.find()
  
  Template.thread.helpers
    posts: -> Posts.find(_tid: Session.get 'tid')
    
  Template.newthread.events
    'submit form': (event) ->
      event.preventDefault()
      name = event.target.name.value.trim()
      if name.length > 0
        content = event.target.content.value.trim()
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
          Session.set 'addthread', false
          Session.set 'tselected', true
          Session.set 'tid', tid
  
  Template.newpost.events
    'submit form': (event) ->
      event.preventDefault()
      content = event.target.content.value.trim()
      if content.length > 0
        # Increase post count
        tid = Session.get 'tid'
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
        event.target.content.value = ""
        
if Meteor.isServer
  Meteor.methods
    insertReplies: (tid, number, repliedTo, id) ->
      for numberRepliedTo in repliedTo
        Posts.update( {_tid: tid, number: numberRepliedTo}, {$push: {replies: number}} )