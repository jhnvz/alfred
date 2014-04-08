#= require alfred

describe 'Alfred', ->

  before ->
    @action   = 'posts/index'
    @name     = 'default'
    @response = JSON.stringify({ posts: [{ title: 'Hi there' }] })
    @meta     = {
      path:   'posts'
      method: 'GET'
      status: 200
      type:   'application/json'
    }

    Alfred.register({
      action:   @action,
      name:     @name,
      meta:     @meta,
      response: @response
    })

    @scenario = Alfred.scenarios[@action][@name]

  describe 'register', ->

    it 'should register scenario', ->
      @scenario.action.should.equal(@action)
      @scenario.name.should.equal(@name)
      @scenario.response.should.equal(@response)
      @scenario.meta.should.equal(@meta)

  describe 'fetch', ->

    it 'should fetch scenario', ->
      Alfred.fetch(@action, @name).should.equal(@scenario)

  describe 'serve', ->

    it 'should serve scenario response', ->
      Alfred.serve(@action, @name).should.equal(@response)
