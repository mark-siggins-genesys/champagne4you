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
