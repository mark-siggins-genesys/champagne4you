((g, e, n, es, ys) ->
  g['_genesysJs'] = e
  g[e] = g[e] or ->
    (g[e].q = g[e].q or []).push arguments
    return
  g[e].t = 1 * new Date
  g[e].c = es
  ys = document.createElement('script')
  ys.async = 1
  ys.src = n
  ys.charset = 'utf-8'
  document.head.appendChild ys
  return
) window, 'Genesys', 'https://apps.inindca.com/genesys-bootstrap/genesys.min.js',
  environment: 'dev'
  deploymentId: '3a7a7215-d6bd-4256-8ef1-2661bd2df2b8'

registerDxPlugin = ->
  Genesys 'registerPlugin', 'GenesysDX', (Dx) ->
    BOLD_CHAT = 'Bold360Action'

    registerChatStateChange = (intendedState, openAction) ->
      console.log 'Producing web action event with state change: ' + intendedState
      Dx.command 'Journey.recordActionStateChange',
        actionId: openAction.journeyContext.triggeringAction.id
        actionState: intendedState
      return

    getAccountId = (configurationFields) ->
      accountId = configurationFields.account_id_enum
      if ! !accountId and accountId.startsWith('_') then accountId.slice(1) else accountId

    getChatConfiguration = (openAction) ->
      openActionProperties = openAction.openActionProperties
      configurationFields = openActionProperties.configurationFields or {}
      # the defaults are for the genbold account
      accountId = getAccountId(configurationFields)
      websiteId = configurationFields.website_id_text
      widgetId = configurationFields.chat_button_id_text
      {
        accountId: accountId
        websiteId: websiteId
        widgetId: widgetId
      }

    loadBoldChat = (openAction) ->
      extractedOpenAction = getChatConfiguration(openAction)
      window._bcvma = window._bcvma or []
      window._bcvma.push [
        'setAccountID'
        extractedOpenAction.accountId
      ]
      window._bcvma.push [
        'setParameter'
        'WebsiteID'
        extractedOpenAction.websiteId
      ]
      window._bcvma.push [
        'addFloat'
        {
          type: 'chat'
          id: extractedOpenAction.widgetId
        }
      ]
      window._bcvma.push [
        'registerChatStatusChangeEventCallback'
        (state) ->
          registerChatStateChange state, openAction
          return
      ]
      window._bcvma.push [ 'pageViewed' ]

      bcLoad = ->
        if window.bcLoaded
          return
        window.bcLoaded = true
        vms = document.createElement('script')
        vms.type = 'text/javascript'
        vms.async = true
        vms.src = 'https://vmss-app51.boldchat.com/aid/' + extractedOpenAction.accountId + '/bc.vms4/vms.js'
        s = document.getElementsByTagName('script')[0]
        s.parentNode.insertBefore vms, s
        registerChatStateChange 'offered', openAction
        return

      if document.readyState == 'complete'
        bcLoad()
      else if window.addEventListener
        window.addEventListener 'load', bcLoad, false
      else
        window.attachEvent 'onload', bcLoad
      return

    Dx.subscribe 'Identifiers.ready', ->
      Dx.ready()
      return
    Dx.subscribe 'Journey.qualifiedOpenAction', (event) ->
      console.log 'Got Journey.qualifiedOpenAction:', event
      # discard non-bold chat open actions
      if event.data.openActionProperties.openActionName == BOLD_CHAT
        loadBoldChat event.data
      return
    return
  return

registerDxPlugin()
Genesys 'configure', debug: true
