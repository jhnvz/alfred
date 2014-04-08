class Alfred.SinonAdapter

  ###*
   * Serves an Alfred response server.
   * @action {String} Controller and action
   * @name {String} Name of the scenario
   *
   * @example
   * server = Alfred.SinonAdapter.serve('sessions/current', 'default')
   * server.respond()
   *
   * @returns
   * {Object} Sinon FakeServer
   *
   ###
  @serve: (action, name) ->
    scenario  = Alfred.fetch(action, name)
    meta      = scenario.meta

    server = sinon.fakeServer.create()
    server.respondWith meta.method, meta.path, [meta.status, { 'Content-Type': meta.type }, scenario.response]

    server
