Template.post.helpers
    prettyTimestamp: ->
        moment(this.timestamp).fromNow()
    prettyReplies: ->
        result = ''
        for reply in this.replies
            result += '>>'
            result += reply
            result += ' '
        return result