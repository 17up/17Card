Card = require("models/card")
Member = require("models/member")
class CardItem extends Spine.Controller
	className: "card_item layer"
	events:
		"hold .card_facade": "make"
		"tap": "turn_face"
	constructor: ->
		super
	render: =>
		@html require("views/items/card")(@item)
	make: (e) ->
		card = @item
		option =
			quality: 80
			targetWidth: 640
			targetHeight: 857
			saveToPhotoAlbum: true
			destinationType: Camera.DestinationType.DATA_URL
		onFail = (msg) ->
			console.log msg
		onSuccess = (imageData) =>
			b64img = "data:image/jpeg;base64," + imageData
			$img = $("img.u_word",@$el)
			$img.attr "src",b64img
			$img.animo
				animation: 'tada'

			onSuccess = (position) ->
				card.lat = position.coords.latitude
				card.lng = position.coords.longitude
				card.altitude = position.coords.altitude
				card.cap_at = position.timestamp
				card.image = b64img
				card.save()
				card.sync()
			onError = (error) ->
				content = error.code + error.message
				console.log content
			# 获取拍摄照片时的位置信息并保存，触发同步
			navigator.geolocation.getCurrentPosition(onSuccess, onError)
		navigator.camera.getPicture onSuccess, onFail, option
	turn_face: (e) ->
		$(".card_wraper",@$el).toggleClass 'obverse'
		onSuccess = ->
			console.log "audio played"
		onError = (error) ->
			content = error.code + error.message
			console.log content
		sound = new Media(@item.audio,onSuccess, onError)
		sound.play()
		this

module.exports = CardItem
