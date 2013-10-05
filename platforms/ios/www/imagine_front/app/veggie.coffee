require('lib/setup')
Start = require("controllers/start")
Spine.Model.host = "http://17up.org"
$(document).on "deviceready", ->
	new Start(el: $("nav"))
	Spine.Route.setup()
	#(history: true)
