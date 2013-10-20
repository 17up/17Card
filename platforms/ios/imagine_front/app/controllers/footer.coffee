Card = require("models/card")
Member = require("models/member")
class Footer extends Spine.Controller
	events:
		"click .sync": "sync"
		"click .micro": "record"
		"click .light": "light"
	constructor: ->
		super
		Card.bind "badge:refresh", @render_badge
	light: (e) ->
		$("#info").html require("views/items/info")(Card.actived())
		$("#info").addClass("show")
	render_badge: ->
		$(".sync .badge",@$el).text Card.unSync().length
	sync: (e) ->
		$target = $(e.currentTarget)
		$target.addClass 'disable_event'
		if Member.checkConnection(Connection.WIFI)
			cards = Card.unSync()
			if cards.length > 0
				$target.find(".icon-refresh").addClass 'icon-spin'
				for card in cards
					card.sync().done =>
						@render_badge()
						if Card.unSync().length is 0
							$target.find(".icon-refresh").removeClass 'icon-spin'
							@notify("所有卡片都已同步到您的17up空间啦","恭喜","知道咯",$target)
			else
				@notify("没有发现未同步的卡片哦","恭喜","OK",$target)
		else if Member.checkConnection(Connection.NONE)
			@notify("系统未监测到网络，无法同步","遗憾","知道咯",$target)
		else
			@notify("建议在 WIFI 网络下执行同步，节省您的流量哦","友情提示","知道咯",$target)
	record: (e) ->
		$target = $(e.currentTarget)
		$target.addClass "recording"
		filename = "mySound"
		uploadMedia = (base64) ->
			card = Card.actived()
			blob = dataURLtoBlob(base64)
			$target.removeClass "recording"
			card.recognize_audio(blob)
		Member.recordMedia(filename,uploadMedia)
	notify: (content,title,button,$target) ->
		cal = ->
			if $target
				$target.removeClass 'disable_event'
			false
		navigator.notification.alert content,cal,title,button
module.exports = Footer
