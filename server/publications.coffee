Meteor.publish 'threads', ->
    Threads.find()
Meteor.publish 'posts', ->
    Posts.find()