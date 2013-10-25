Member = require("models/member")
Cards = require("controllers/cards")
Footer = require("controllers/footer")
class Header extends Spine.Controller
	events:
		"click": "config"
	constructor: ->
		super
		Member.bind 'refresh', @render
		Member.fetch()
	render: =>
		new Footer(el: $("footer"))
		new Cards(el: $("article"))
		if Member.is_new
			@config()
			Member.is_new = false
		this
	config: ->
		$("#help").addClass("show")
		$(".title",@$el).animo
			animation: 'tada'

module.exports = Header
