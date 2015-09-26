Template.post.helpers
    prettyContent: ->
        # Escape post content, then inject our HTML for unescaped rendering
        safeContent = _.escape(this.content)
        replyRegex = new RegExp(/&gt;&gt;\d+/g)
        insertBacklink = (match) ->
            result = "<a href='#p"
            result += match[8..]
            result += "' class='backlink'>"
            result += match
            result += '</a>'
            return result
        return safeContent.replace(replyRegex, insertBacklink)
    prettyTimestamp: ->
        moment(this.timestamp).fromNow()
    prettyReplies: ->
        result = ''
        for reply in this.replies
            result += '>>'
            result += reply
            result += ' '
        return result