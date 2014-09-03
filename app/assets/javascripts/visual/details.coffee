$ ->
  $('details').details()
  $('.l-main').on 'click', 'summary', onSummaryClick
  $('.l-main').on 'ajax:beforeSend', '.js-library-ajax .pagination a[data-remote=true]', onAjaxBeforeSend

onSummaryClick = (evt) ->
    [target, summary, details] = [evt.target, evt.currentTarget, evt.currentTarget.parentElement]
    id = details.id
    libraryID = id.split('library')[1]

    unless $(target).parentsUntil(summary).add($(target)).is('a, button, input')
      $(".Library:not(#library#{libraryID})").attr("open", null) # close all others
      updateLinks $(details).find('a[data-remote=true]'), libraryID
      document.Fairnopoly.historyPush true, # push history
        window.location.href.setParameter
          focus: libraryID
          library_page: $(details).attr('data-library-page')

      $("html, body").animate({ scrollTop: $("#library#{libraryID}").offset().top }, 200) # scroll

onAjaxBeforeSend = ->
    # update library page storage
    page = @href.getParameter('library_page')
    $(@).parents('.Library').attr 'data-library-page', page
    # gray out to show that something is happening
    $(@).parents('.js-library-ajax').children('.Grid--wider').css('opacity', '0.4')
    # push library_page to history
    document.Fairnopoly.historyPush true,
      window.location.href.setParameter
        library_page: page

updateLinks = (links, focusID) ->
  for link in links
    $link = $(link)
    oldURL = $link.attr('href')

    $link.attr 'href',
      oldURL.setParameter
        focus: focusID

# parameter evaluation. could become useful elsewhere
String.prototype.getParameter = (paramName) ->
  searchString = @split('?').pop()
  params = searchString.split '&'

  for i in [0..params.length-1]
    val = params[i].split '='
    if val[0] is paramName
      return val[1]

  null

#can only replace numbers until now
String.prototype.setParameter = (param_hash) ->
  url = @
  for param, value of param_hash
    oldValue = url.getParameter(param)
    if oldValue and oldValue isnt value
      regex = new RegExp("(\\?|&)#{param}=\\d*")
      glueSign = url.charAt url.search(regex)
      url = url.replace(regex, if value then "#{glueSign}#{param}=#{value}" else '')
    else if not oldValue
      url += if url.indexOf('?') >= 0 then "&#{param}=#{value}" else "?#{param}=#{value}"

  url

