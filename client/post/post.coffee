Template.post.helpers
    prettyContent: ->
        # Escape post content, then inject our HTML for unescaped rendering
        replyRegex = new RegExp(/&gt;&gt;\d+/g)
        insertBacklink = (match) ->
            result = "<a href='#"
            result += match[8..]
            result += "' class='backlink'>"
            result += match
            result += '</a>'
            return result
        quoteRegex = new RegExp(/^&gt;.*/mg)
        insertQuote = (match) ->
            result = "<span class='quote'>"
            result += match
            result += '</span>'
            return result
        safeContent = _.escape(@content)
        return safeContent.replace(replyRegex, insertBacklink).replace(quoteRegex, insertQuote)
    prettyTimestamp: ->
        moment(@timestamp).fromNow()
    prettyForelinks: ->
        result = ''
        for reply in @replies
            result += "<a href='#"
            result += reply
            result += "' class='forelink'>>>"
            result += reply
            result += '</a> '
        return result