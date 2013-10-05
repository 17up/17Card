Card = require("models/card")
Member = require("models/member")
class Footer extends Spine.Controller
	events:
		"click .sync": "sync"
		"click .config": "config"
		"click #help": "close_help"
	constructor: ->
		super
		@append @render()
		if Member.newer
			@config()
			Member.newer = false
	render: =>
		cnt = Card.check_unSync().length
		@html require("views/footer")(cnt: cnt)
	sync: (e) ->
		$target = $(e.currentTarget)
		$target.addClass 'disable_event'
		$target.find(".icon-refresh").addClass 'icon-spin'
		cards = Card.check_unSync()
		for card in cards
			card.sync()
		@render()
		@notify('所有卡片都已同步到您的17up空间啦',"恭喜","知道咯")
	config: ->
		$("#help").addClass("show").animo
			animation: 'swing'
	close_help: (e) ->
		$(e.currentTarget).removeClass "show"
	notify: (content,title,button) ->
		cal = ->
			false
		navigator.notification.alert content,cal,title,button
module.exports = Footer
