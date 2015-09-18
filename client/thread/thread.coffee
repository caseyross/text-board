Template.thread.helpers
  posts: -> Posts.find(_tid: Session.get 'tid')