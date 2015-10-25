Meteor.subscribe 'threads'

Tracker.autorun ->
    Meteor.subscribe 'posts', FlowRouter.getParam '_id'