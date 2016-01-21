Template.catalog.helpers
    threads: -> Threads.find({}, {sort: {'modified': -1}})
    prettyPostCount: ->
        if @postCount == 1
            '1 post'
        else
            @postCount + ' posts'
    
Template.catalog.events
    'click #newThread': (event) ->
        FlowRouter.go '/new'