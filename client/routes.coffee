FlowRouter.route '/',
    action: ->
        BlazeLayout.render 'catalog'
    
FlowRouter.route '/:_id',
    action: ->
        BlazeLayout.render 'thread'
    
FlowRouter.route '/new',
    action: ->
        BlazeLayout.render 'newthread'