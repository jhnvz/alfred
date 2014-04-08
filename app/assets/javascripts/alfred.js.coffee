class @Alfred

  @scenarios: {}

  ###*
   * Fetches an Alfred response.
   * @action {String} Controller and action
   * @name {String} Name of the scenario
   *
   * @example
   * Alfred.fetch('sessions/current', 'default')
   *
   * @returns
   * {Object} Scenario object
   *
   ###
  @fetch: (action, name) ->
    @scenarios[action]?[name]

  ###*
   * Serves an Alfred response.
   * @action {String} Controller and action
   * @name {String} Name of the scenario
   *
   * @example
   * Alfred.serve('sessions/current', 'default')
   *
   * @returns
   * {String} Scenario response string
   *
   ###
  @serve: (action, name) ->
    @fetch(action, name)?.response

  ###*
   * Registers an Alfred response.
   * @action {String} Controller and action
   * @name {String} Name of the scenario
   * @meta {Object} Meta data of the response
   * @response {String} Scenario response
   *
   * @example
   * Alfred.register({
   *   action:   'sessions/current',
   *   name:     'default',
   *   meta:     { path: 'api/1/sessions', method: 'GET' },
   *   response: @response
   * })
   *
   ###
  @register: (object) ->
    @scenarios[object.action] ||= {}
    @scenarios[object.action][object.name] = {
      name:     object.name
      action:   object.action
      meta:     object.meta
      response: object.response
    }
