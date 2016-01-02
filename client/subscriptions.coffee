Meteor.subscribe 'threads'

Tracker.autorun ->
    tid = FlowRouter.getParam '_id'
    if tid != undefined
        Meteor.subscribe 'posts', tid