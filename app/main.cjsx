init = require './init'
React = require 'react'
Classifier = require './classifier'
Profile = require './profile'
UserStatus = require './user-status'
Panoptes = require 'panoptes-client'
a11y = require 'react-a11y'

a11y_options =
  includeSrcNode: true

# a11y React, a11y_options

# let's try talking to panoptes by getting the current user and some subjects for a known workflow
client = new Panoptes
  appID: '535759b966935c297be11913acee7a9ca17c025f9f15520e7504728e71110a27'
  host: 'https://panoptes-staging.zooniverse.org'

auth = client.api.auth
  
render = (response) ->
  user = response
  React.render <Profile user=user />, document.querySelector '#profile'
  React.render <UserStatus user=user auth=client.api.auth />, document.querySelector '#user-status'
  React.render <Classifier api=client.api />, document.querySelector '#classify'

handleAuthChange = (e) ->
  auth
    .checkCurrent()
    .then( render )

auth.listen handleAuthChange

handleAuthChange()

window.React = React
