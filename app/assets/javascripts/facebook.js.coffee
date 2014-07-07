jQuery ->

  _sg = _SG

  currentUser = _sg.CurrentUser

  loggedIn = currentUser.name?

  fbAuthStatusChange = (response) ->
    authorizeUser(response) if response? and loggedIn?

  authorizeUser = (response) ->
    readableStatus = response.status in ["unknown", "not_authorized", "connected"]

    doRedirect() if readableStatus and shouldRedirect(response)

  shouldRedirect = (response) ->
    return false unless currentUser.FB_UID?
    return true unless response.authResponse?
    response.authResponse.userID isnt currentUser.FB_UID

  doRedirect = ->
    window.location.href = "/logout?fb=true"

  $(document).on 'fb:initialized', ->
    FB.getLoginStatus(fbAuthStatusChange)

  $(document).fb _sg.Config.FB_APP_ID