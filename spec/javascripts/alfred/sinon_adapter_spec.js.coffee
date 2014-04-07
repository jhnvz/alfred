#= require alfred
#= require alfred/sinon_adapter

describe 'Alfred.SinonAdapter', ->

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

    Alfred.register(@action, @name, @meta, @response)

    @scenario = Alfred.scenarios[@action][@name]

  describe 'serve', ->

    it 'should setup a sinon fakeServer', ->
      server = Alfred.SinonAdapter.serve(@action, @name)
      response = server.responses[0]

      response.method.should.equal('GET')
      response.url.should.equal('posts')
