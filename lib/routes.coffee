FlowRouter.route '/',
    action: ->
        BlazeLayout.render 'catalog'
    
FlowRouter.route '/thread/:_id',
    action: ->
        BlazeLayout.render 'thread'
    
FlowRouter.route '/new',
    action: ->
        BlazeLayout.render 'new_thread'