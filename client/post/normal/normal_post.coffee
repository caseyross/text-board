Template.normal_post.helpers
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
        quoteRegex = new RegExp(/(^&gt;.*\n?)+/mg)
        insertQuote = (match) ->
            quoteBracketsRegex = new RegExp(/^&gt;\s?/mg)
            result = "<blockquote>"
            result += match.replace(quoteBracketsRegex, '')
            result += '</blockquote>'
            return result
        safeComment = _.escape(@comment)
        return safeComment.replace(replyRegex, insertBacklink).replace(quoteRegex, insertQuote)
    prettyImageName: ->
        name = @image.name
        if name.length > 255
            return name.substring(0, 255) + '...'
        return name
    prettyImageDimensions: ->
        return @image.width + ' × ' + @image.height
    isoDatetime: ->
        moment(@timestamp).toISOString()
    prettyDatetime: ->
        moment(@timestamp).format 'dddd, MMMM Do, YYYY - h:mm:ss A'
    prettyTime: ->
        time = moment(@timestamp)
        now = moment()
        if time.isSame(now, 'day')
            return time.format 'h:mm A'
        if now.date() - time.date() < 7
            return time.format 'ddd h:mm A'
        return time.format 'MMM D, YYYY'
    prettyForelinks: ->
        result = ''
        for reply in @replies
            result += "<a href='#"
            result += reply
            result += "' class='forelink'>>>"
            result += reply
            result += '</a> '
        return result
        
Template.normal_post.events
    'click .thumb': (event) ->
        toggleFullImage on, @number
    'click .full': (event) ->
        toggleFullImage off, @number
        
toggleFullImage = (status, number) ->
    thumb = document.getElementById('t' + number)
    full = document.getElementById('f' + number)
    fullImage = document.getElementById('i' + number)
    postBody = thumb.parentElement
    postContainer = document.getElementById(number)
    if status
        fullImage.src = fullImage.dataset.src
        thumb.classList.add('absent')
        full.classList.remove('absent')
    else
        full.classList.add('absent')
        thumb.classList.remove('absent')