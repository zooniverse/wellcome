init = require './init'
React = require 'react'
Classifier = require './classifier'
Profile = require './profile'
UserStatus = require './user-status'
Panoptes = require 'panoptes-client'
Projects = require './lib/projects'
a11y = require 'react-a11y'

a11y_options =
  includeSrcNode: true

# a11y React, a11y_options

Main = React.createClass
  displayName: 'Main'
  
  projects: null
  client: null
  
  getInitialState: ->
    user: null
    project: null
  
  componentWillMount: ->
    @client = new Panoptes
      appID: '535759b966935c297be11913acee7a9ca17c025f9f15520e7504728e71110a27'
      host: 'https://panoptes-staging.zooniverse.org'
      
    @projects = new Projects @client.api
    
    @client.api.auth.listen @handleAuthChange

    @client.api.auth.checkCurrent()
  
  componentDidUpdate:->
    React.render <Profile project={@state.project} user={@state.user} />, document.querySelector '#profile'
    React.render <UserStatus user={@state.user} auth={@client.api.auth} />, document.querySelector '#user-status'
    React.render <Classifier project={@state.project} user={@state.user} api={@client.api} />, document.querySelector '#classify'
  
  render: ->
    <div className="readymade-home-page-content">
      <div className="readymade-creator">
          <div className="readymade-project-producer">Wellcome Library &amp; Zooniverse</div>
          <h1 className="readymade-project-title">{@state.project?.display_name}</h1>
      </div>
      <div className="readymade-project-summary"> Mapping work and public health in the London MOH reports </div>
      <div className="readymade-project-description"> Short description </div>
      <div className="readymade-footer"> <a href="#/classify" className="readymade-call-to-action"> Get started! </a> </div>
    </div>
  
  handleAuthChange: (e) ->
    @client.api.auth
      .checkCurrent()
      .then (user) =>
        @setState {user}
    
        @projects?.fetch().then =>
          project = @projects.current()
          @setState {project}

React.render <Main />, document.querySelector '#home'