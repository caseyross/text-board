Threads = new Mongo.Collection 'threads'
Posts = new Mongo.Collection 'posts' # Need to model these as part of Thread documents to ensure atomic thread updates?

# TODO: Figure out why this stuff doesn't work when separated and put in client files
if Meteor.isClient
    
  Template.catalog.helpers
    threads: -> Threads.find()
  
  Template.thread.helpers
    posts: -> Posts.find(_tid: Session.get 'tid')
    
  Template.newthread.events
    'submit form': (event) ->
      event.preventDefault()
      name = event.target.name.value
      if name.trim().length > 0
        content = event.target.content.value
        if content.trim().length > 0
          tid = Threads.insert
            name: name
          Posts.insert
            _tid: tid
            content: content
          Session.set 'addthread', false
          Session.set 'tselected', true
          Session.set 'tid', tid
  
  Template.newpost.events
    'submit form': (event) ->
      event.preventDefault()
      content = event.target.content.value
      if content.trim().length > 0
        Posts.insert
          _tid: Session.get 'tid'
          content: content
          timestamp: +moment()
          replies: []
        event.target.content.value = ""