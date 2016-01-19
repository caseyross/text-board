Template.catalog.helpers
    threads: -> Threads.find({}, {sort: {'modified': -1}})
    
Template.catalog.events
    'click #newThread': (event) ->
        FlowRouter.go '/new'