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
        
Template.post.events
    'click .post-image': (event) ->
        toggleFullImage on, @number
    'click .post-image-full': (event) ->
        toggleFullImage off, @number
        
toggleFullImage = (status, number) ->
    img = document.getElementById('img' + number)
    imgf = document.getElementById('imgf' + number)
    postBody = img.parentElement
    postContainer = document.getElementById(number)
    if status
        imgf.children[0].src = imgf.children[0].dataset.src
        img.classList.add('absent')
        imgf.classList.remove('absent')
        postBody.classList.add('expanded-image')
        postContainer.classList.add('expanded-image')
    else
        imgf.classList.add('absent')
        img.classList.remove('absent')
        postBody.classList.remove('expanded-image')
        postContainer.classList.remove('expanded-image')