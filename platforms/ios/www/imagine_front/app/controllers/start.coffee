Member = require("models/member")
Card = require("models/card")
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
		@footer = new Footer(el: $("footer"))
		@cards = new Cards(el: $("article"))
		@append @html require('views/start')()
		@start()
		navigator.splashscreen.hide()
		this
	updateProgress: ->
		cnt = Card.count()
		un = Card.unComplete().length
		percent = parseInt (cnt - un)*100/cnt
		$(".progress span.num").text percent
	start: (e) ->
		if @isActive()
			@deactivate()
			@footer.deactivate()
			@updateProgress()
			$(".dancing").animo
				animation: 'tada'
		else
			@activate()
			@footer.activate()
module.exports = Start
