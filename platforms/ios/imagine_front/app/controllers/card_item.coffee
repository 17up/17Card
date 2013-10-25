Card = require("models/card")
Member = require("models/member")
class CardItem extends Spine.Controller
	className: "card_item"
	events:
		"hold": "make"
		"click": "playAudio"
		"click .share": "share"
	constructor: ->
		super
		@item.bind "deactive", @release
		@item.bind "share:show", @showShare
	render: =>
		@html require("views/items/card")(@item)
	share: (e) ->
		e.stopPropagation()
		word = @item.title
		window.plugins.socialsharing.share("快来看我做的单词卡片 #{word}",null,@item.image_url)
	showShare: =>
		@$el.find(".share").show()
	make: (e) ->
		e.preventDefault()
		$target = $(e.currentTarget)
		$target.addClass 'disable_event'
		card = @item

		option =
			quality: 70
			targetWidth: 640
			targetHeight: 857
			# saveToPhotoAlbum: true
			destinationType: Camera.DestinationType.DATA_URL
			# allowEdit: true
		onFail = (msg) ->
			console.log msg
			$target.removeClass 'disable_event'
		onSuccess = (imageData) =>
			b64img = "data:image/jpeg;base64," + imageData
			$img = $("img.u_word",@$el)
			$img.attr "src",b64img
			$img.animo
				animation: 'tada'
			$target.removeClass 'disable_event'
			saveImg = (c) ->
				c.image = b64img
				c.save()
				c.sync()
			onSuccess = (position) ->
				card.lat = position.coords.latitude
				card.lng = position.coords.longitude
				card.altitude = position.coords.altitude
				card.cap_at = position.timestamp
				saveImg(card)

			onError = (error) ->
				console.log error.code + error.message
				card.cap_at = new Date()
				saveImg(card)
			# 获取拍摄照片时的位置信息并保存，触发同步
			navigator.geolocation.getCurrentPosition(onSuccess, onError)
		navigator.camera.getPicture onSuccess, onFail, option
	playAudio: (e) ->
		unless Member.checkConnection(Connection.NONE)
			src = "http://tts.yeshj.com/uk/s/" + encodeURIComponent(@item.title)
			Member.playSound(src)

module.exports = CardItem
