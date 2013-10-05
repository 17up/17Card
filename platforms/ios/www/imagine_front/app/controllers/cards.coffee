CardItem = require("controllers/card_item")
Card = require("models/card")
class Cards extends Spine.Controller
	className: "kontext"
	constructor: ->
		super
		Card.bind 'refresh', @render
		Card.fetch()
	render: =>
		@addAll()
		@setupKontext(".kontext")
	addOne: (item) =>
		card = new CardItem(item: item)
		@append(card.render())
	addAll: =>
		Card.each(@addOne)
	@updateProgress: ->
		cnt = Card.count()
		un = Card.check_unComplete().length
		percent = parseInt (cnt - un)*100/cnt
		$(".progress").text(percent + "%")
	setupKontext: (query) ->
		k = kontext document.querySelector(query)
		$first = $(".layer:first")
		$first.addClass('show')
		$("img.u_word").unveil 100, ->
			$(@).load ->
				@style.opacity = 1
		$first.find("img").trigger("unveil")
		touchConsumed = false
		lastX = 0
		document.addEventListener 'touchstart', ( event ) ->
			touchConsumed = false
			lastX = event.touches[0].clientX
		, false
		document.addEventListener 'touchmove', ( event ) ->
			event.preventDefault()
			if !touchConsumed
				if event.touches[0].clientX > lastX + 10
					k.prev()
					touchConsumed = true
				else if event.touches[0].clientX < lastX - 10
					k.next()
					touchConsumed = true
		, false
		k.changed.add ( layer, index ) ->
			$(layer).find("img").trigger("unveil")

module.exports = Cards
