Template.post.helpers
    prettyComment: ->
        # Escape post comment, then inject our HTML for unescaped rendering
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
        safeComment = _.escape(@comment)
        return safeComment.replace(replyRegex, insertBacklink).replace(quoteRegex, insertQuote)
    isoDatetime: ->
        moment(@timestamp).toISOString()
    prettyTime: ->
        moment(@timestamp).format 'h:mm A'
    prettySeconds: ->
        moment(@timestamp).format 'ss.SSS'
    prettyForelinks: ->
        result = ''
        for reply in @replies
            result += "<a href='#"
            result += reply
            result += "' class='forelink'>>>"
            result += reply
            result += '</a> '
        return result
        
Template.post.events
    'click img.thumb': (event) ->
        toggleFullImage on, @number
    'click img.full': (event) ->
        toggleFullImage off, @number
        
toggleFullImage = (status, number) ->
    thumb = document.getElementById('t' + number)
    full = document.getElementById('i' + number)
    postBody = thumb.parentElement
    postContainer = document.getElementById(number)
    if status
        full.src = full.dataset.src
        thumb.classList.add('absent')
        full.classList.remove('absent')
    else
        full.classList.add('absent')
        thumb.classList.remove('absent')