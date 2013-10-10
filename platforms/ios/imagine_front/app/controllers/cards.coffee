CardItem = require("controllers/card_item")
Card = require("models/card")
class Cards extends Spine.Controller
	constructor: ->
		super
		Card.bind 'refresh', @render
		Card.fetch()
	render: =>
		Card.trigger "badge:refresh"
		@addOne Card.actived()
	addOne: (item) =>
		card = new CardItem(item: item)
		@append(card.render())

module.exports = Cards
