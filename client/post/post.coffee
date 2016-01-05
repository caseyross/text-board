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
            result = "<blockquote>"
            result += match
            result += '</blockquote>'
            return result
        safeComment = _.escape(@comment)
        return safeComment.replace(replyRegex, insertBacklink).replace(quoteRegex, insertQuote)
    isoDatetime: ->
        moment(@timestamp).toISOString()
    prettyDatetime: ->
        moment(@timestamp).format 'dddd, MMMM Do, YYYY - h:mm.ss A'
    prettyTime: ->
        moment(@timestamp).format 'h:mm A'
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
    'click .thumb': (event) ->
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