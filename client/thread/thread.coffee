Template.thread.helpers
    posts: -> Posts.find(_tid: FlowRouter.getParam '_id' )