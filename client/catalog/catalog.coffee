Template.catalog.helpers
    threads: -> Threads.find()
    
Template.catalog.events
    'click #newThread': (event) ->
        FlowRouter.go '/new'