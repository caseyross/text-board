Meteor.publish 'threads', ->
    return Threads.find()
Meteor.publish 'posts', (tid) ->
    return Posts.find(_tid: tid)