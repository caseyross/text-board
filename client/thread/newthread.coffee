Template.newthread.events
  'submit form': (event) ->
    event.preventDefault()
    title = event.target.title.value
    firstPost = event.target.firstPost.value
    Meteor.call 'postThread', title, firstPost, (error, result) ->
      if result
        newPath = '/thread/' + result
        FlowRouter.go(newPath)