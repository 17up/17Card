Card = require("models/card")
class Search extends Spine.Controller
	events:
		"click .word": "select"
	constructor: ->
		super
		$("body").addClass "searchable"
		@$el.drag_search()
		toolbar.hide()
		$("#search_input").bind "input propertychange",$.debounce(1000,@render)
	render: ->
		str = $.trim $(this).val()
		if str isnt ""
			$("#search .container").html require("views/result")(words: Card.search_by(str))
		else
			$("#search .container").empty()
	select: (e) ->
		title = $(e.currentTarget).text()
		card = Card.findByAttribute "title", title
		card.setActived()
		$("#search .cancel").trigger "click"
module.exports = Search
