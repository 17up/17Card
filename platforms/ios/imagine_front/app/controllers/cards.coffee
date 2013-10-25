CardItem = require("controllers/card_item")
Search = require("controllers/search")
Card = require("models/card")
class Cards extends Spine.Controller
	constructor: ->
		super
		Card.bind 'refresh', @render
		Card.bind 'imagine', @imagine
		Card.fetch()
	render: =>
		Card.trigger "badge:refresh"
		new Search(el: $("#search"))
		@imagine()
		navigator.splashscreen.hide()
	imagine: =>
		card = new CardItem(item: Card.actived())
		@append(card.render())
module.exports = Cards
