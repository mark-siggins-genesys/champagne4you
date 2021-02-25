nav_button = document.querySelector('.nav-button')
navigation = document.querySelector('.navigation')

# Listen for click event
nav_button.addEventListener 'click', (->

  # open navigation and change toggle button
  navigation.classList.toggle 'open'
  nav_button.classList.toggle 'active'
), false

window._genesys = widgets: webchat: transport:
  type: 'purecloud-v2-sockets'
  dataURL: 'https://api.mypurecloud.ie'
  deploymentKey: 'caa0323a-7079-4d55-b777-c49db1fe1206'
  orgGuid: '77da0b5f-76dd-40b7-a30c-9f14130bc9e9'
  interactionData: routing:
    targetType: 'QUEUE'
    targetAddress: 'SalesHotProspects'
    priority: 2
