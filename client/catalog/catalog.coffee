Template.catalog.helpers
    threads: -> Threads.find()
    
Template.catalog.events
    'click .goto-new-thread-btn': (event) ->
        FlowRouter.go '/new'