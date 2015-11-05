FlowRouter.route '/',
    action: ->
        BlazeLayout.render 'catalog'
    
FlowRouter.route '/new',
    action: ->
        BlazeLayout.render 'new_thread'
    
FlowRouter.route '/t/:_id',
    action: ->
        BlazeLayout.render 'thread'
        
FlowRouter.route '/i/:public_id',
    action: ->
        BlazeLayout.render 'image'