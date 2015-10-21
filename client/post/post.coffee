Template.post.helpers
    #numberAttrs: ->
        #'class':
            #switch
                #when this.number < 10 then 'post-number-lg'
                #when this.number < 100 then 'post-number-md'
                #else 'post-number-sm'
    prettyContent: ->
        # Escape post content, then inject our HTML for unescaped rendering
        safeContent = _.escape(this.content)
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
        moment(this.timestamp).fromNow()
    prettyForelinks: ->
        result = ''
        for reply in this.replies
            result += "<a href='#"
            result += reply
            result += "' class='forelink'>"
            result += reply
            result += '</a> '
        return result