Template.thread.helpers
    posts: -> Posts.find(_tid: FlowRouter.getParam '_id' )
    
Template.thread.events
    'click .postReplyBtn': (event) ->
        replyLink = '>>'
        replyLink += this.number
        replyLink += '\n'
        input = Session.get 'postInput'
        cursorPos = Session.get 'postInputCursorPos'
        input = input[0...cursorPos] + replyLink + input[cursorPos..]
        Session.set 'postInput', input