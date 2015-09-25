Router.route '/', ->
    this.render 'catalog'
    
Router.route '/:_id', ->
    posts = Posts.find(_tid: this.params._id)
    this.render 'thread'
    
Router.route '/new', ->
    this.render 'newthread'