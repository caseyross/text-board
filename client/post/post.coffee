Template.post.helpers
    numberAttrs: ->
        'class':
            switch
                when this.number < 10 then 'numberLg'
                when this.number < 100 then 'numberMd'
                else 'numberSm'
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
            result += "<a href='#p"
            result += reply
            result += "'>>>"
            result += reply
            result += '</a> '
        return result