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
   * Alfred.register('sessions/current', 'default', { path: 'api/1/sessions', method: 'GET' }, response)
   *
   ###
  @register: (action, name, meta, response) ->
    @scenarios[action] ||= {}
    @scenarios[action][name] = {
      name:     name
      action:   action
      meta:     meta
      response: response
    }
