Card = require("models/card")
Member = require("models/member")
class CardItem extends Spine.Controller
	className: "card_item"
	events:
		"hold .card_facade": "make"
		"tap": "turn_face"
	constructor: ->
		super
	render: =>
		@html require("views/items/card")(@item)
	make: (e) ->
		e.preventDefault()
		$target = $(e.currentTarget)
		$target.addClass 'disable_event'
		card = @item

		option =
			quality: 90
			targetWidth: 640
			targetHeight: 857
			saveToPhotoAlbum: true
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
	turn_face: (e) ->
		Member.playSound(@item.audio)
		this

module.exports = CardItem
