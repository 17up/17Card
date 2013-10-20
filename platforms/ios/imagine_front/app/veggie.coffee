require('lib/setup')
Header = require("controllers/header")
Spine.Model.host = "http://17up.org"
$(document).on "deviceready", ->
	new Header(el: $("nav"))
	Spine.Route.setup()
	#(history: true)

	handleOpenURL = (url) ->
		console.log url
window.addEventListener 'load', ->
	FastClick.attach(document.body)
,false

$ ->
	$(".modal").on "click", ->
		$(@).removeClass "show"

