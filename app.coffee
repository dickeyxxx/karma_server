_ = require('underscore')
express = require("express")
cors = require("cors")
store = require './app/store'
redis = require './redis'
app = express()
app.use express.logger()
app.use cors()
app.use express.bodyParser()

app.REDIS_NAMESPACE = 'karma'

app.store = ->
  if not app.karmaStore?
    app.karmaStore = new store.Store app.REDIS_NAMESPACE
  app.karmaStore

app.get "/", (request, response) ->
  response.send "Karma app."

app.get "/leaderboard", (request, response) ->
  app.store().leaderboard (entries) ->
    response.send entries

app.get "/upvotes", (request, response) ->
  app.store().upvotes (upvotes) ->
    response.send upvotes

app.post "/upvote", (request, response) ->
  app.store().upvote request.body.user, request.body.comments
  response.send 200

port = process.env.PORT or 5000
app.listen port, ->
  console.log "Listening on " + port

exports.app = app
