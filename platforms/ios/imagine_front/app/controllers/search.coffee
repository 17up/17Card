Card = require("models/card")
class Search extends Spine.Controller
	events:
		"click .word": "select"
	constructor: ->
		super
		@$el.drag_search()
		toolbar.hide()
		$("#search_input").bind "input propertychange",$.debounce(1000,@render)
	render: ->
		str = $.trim $(this).val()
		$container = $("#search .container")
		if str.length > 0
			if str.length > 1
				words = Card.search_by(str)
			else
				words = Card.group_by(str)
			$container.html require("views/result")(words: words)
		else
			$container.empty()
	select: (e) ->
		title = $(e.currentTarget).text()
		card = Card.findByAttribute "title", title
		card.setActived()
		$("#search .cancel").trigger "click"
module.exports = Search
