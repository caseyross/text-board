Threads = new Mongo.Collection 'threads'
Posts = new Mongo.Collection 'posts'

if Meteor.isClient
  
  Session.setDefault 'tselected', false
  Session.setDefault 'tid', undefined
  Session.setDefault 'addthread', false
  
  Template.body.helpers
    tselected: -> Session.get 'tselected'
    addthread: -> Session.get 'addthread'
    
  Template.body.events
    'click .back': ->
      Session.set 'tselected', false
      Session.set 'tid', undefined
      Session.set 'addthread', false
    
  Template.catalog.helpers
    threads: -> Threads.find()
    
  Template.catalog.events
    'click li': (event) ->
      Session.set 'tselected', true
      Session.set 'tid', event.target.id
    'click .new': (event) ->
      Session.set 'addthread', true
  
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
        event.target.content.value = ""
  
if Meteor.isServer
  Meteor.startup
  