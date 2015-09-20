Session.setDefault 'tselected', false
Session.setDefault 'tid', undefined
Session.setDefault 'addthread', false

Threads = new Mongo.Collection 'threads'
Posts = new Mongo.Collection 'posts'

Meteor.subscribe 'threads'
# Autosubscribe to each thread's posts when user opens it
# Might be worth sub'ing to all posts for speed
Tracker.autorun ->
  Meteor.subscribe 'posts', Session.get 'tid'
    
Template.catalog.helpers
  threads: -> Threads.find()

Template.thread.helpers
  posts: -> Posts.find(_tid: Session.get 'tid')