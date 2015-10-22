Template.post.helpers
    prettyContent: ->
        # Escape post content, then inject our HTML for unescaped rendering
        safeContent = _.escape(@content)
        replyRegex = new RegExp(/&gt;&gt;\d+/g)
        insertBacklink = (match) ->
            number = match[8..]
            result = "<a href='#"
            result += number
            result += "' class='backlink'>"
            result += number
            result += '</a>'
            return result
        return safeContent.replace(replyRegex, insertBacklink)
    prettyTimestamp: ->
        moment(@timestamp).fromNow()
    prettyForelinks: ->
        result = ''
        for reply in @replies
            result += "<a href='#"
            result += reply
            result += "' class='forelink'>"
            result += reply
            result += '</a> '
        return result