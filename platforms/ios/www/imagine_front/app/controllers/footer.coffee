Card = require("models/card")
Member = require("models/member")
class Footer extends Spine.Controller
	events:
		"click .sync": "sync"
		"click .config": "config"
		"click #help": "close_help"
		"click .micro": "record"
	constructor: ->
		super
		Card.bind "badge:refresh", @render_badge
		@append @render()
		if Member.newer
			@config()
			Member.newer = false
	render: =>
		@html require("views/footer")()
	render_badge: ->
		$(".sync .badge",@$el).text Card.unSync().length
	sync: (e) ->
		$target = $(e.currentTarget)
		$target.addClass 'disable_event'
		if Member.checkConnection(Connection.WIFI)
			$target.find(".icon-refresh").addClass 'icon-spin'
			for card in Card.unSync()
				card.sync().done =>
					@render_badge()
					if Card.unSync().length is 0
						$target.removeClass 'disable_event'
						$target.find(".icon-refresh").removeClass 'icon-spin'
						@notify("所有卡片都已同步到您的17up空间啦","恭喜","知道咯")
		else if Member.checkConnection(Connection.NONE)
			@notify("系统未监测到网络，无法同步","遗憾","知道咯")
			$target.removeClass 'disable_event'
		else
			@notify("建议在 WIFI 网络下执行同步，节省您的流量哦","友情提示","知道咯")
			$target.removeClass 'disable_event'
	config: ->
		$("#help").addClass("show").animo
			animation: 'swing'
	record: (e) ->
		$target = $(e.currentTarget)
		Member.recordMedia("mySound",$target)
	close_help: (e) ->
		$(e.currentTarget).removeClass "show"
	notify: (content,title,button) ->
		cal = ->
			false
		navigator.notification.alert content,cal,title,button
module.exports = Footer
