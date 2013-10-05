Member = require("models/member")
Cards = require("controllers/cards")
Footer = require("controllers/footer")
class Start extends Spine.Controller
	className: "start"
	events:
		"click": "start"
	constructor: ->
		super
		Member.bind 'refresh', @render
		Member.fetch()
	render: =>
		new Footer(el: $("footer"))
		new Cards(el: $("article"))
		@append @html require('views/start')()
		@activate()
		navigator.splashscreen.hide()
		$(".dancing").animo
			animation: 'tada'
		this
	start: (e) ->
		# Member.checkConnection()
		if @isActive()
			@deactivate()
		else
			@activate()
module.exports = Start
