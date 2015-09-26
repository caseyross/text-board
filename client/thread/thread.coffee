Template.thread.helpers
    posts: -> Posts.find(_tid: FlowRouter.getParam '_id' )
    
Template.thread.events
    'click .postReplyBtn': (event) ->
        input = Session.get 'postInput'
        input += '>>'
        input += this.number
        input += '\n'
        Session.set 'postInput', input