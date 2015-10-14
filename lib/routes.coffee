FlowRouter.route '/',
    action: ->
        BlazeLayout.render 'catalog'
    
FlowRouter.route '/t/:_id',
    action: ->
        BlazeLayout.render 'thread'
    
FlowRouter.route '/new',
    action: ->
        BlazeLayout.render 'new_thread'