Template.post_overlay.helpers
    overlay: ->
        if Session.get 'post_overlay'
            return Posts.findOne {number: parseInt(Session.get 'post_overlay', 10)}
        else
            return undefined