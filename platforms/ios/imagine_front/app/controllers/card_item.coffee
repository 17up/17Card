Card = require("models/card")
Member = require("models/member")
class CardItem extends Spine.Controller
	className: "card_item"
	events:
		"hold .pane1": "make"
		"tap .pane1": "playAudio"
		"tap .wp": "picDetail"
	constructor: ->
		super
		@item.bind "deactive", @release
	render: =>
		@html require("views/items/card")(@item)
	init: ->
		@$el.carousel()
		@getPics()
	getPics: ->
		onSuccess = (data) =>
			if data.status is 0
				pics = for item in data.data
					$.extend {},item,image: Spine.Model.host + item.image
				$("li.pane2",@$el).html require("views/items/pane2")(pics: pics)
		onFail = (err) ->
			console.log err
		@item.getPics(onSuccess,onFail)
	picDetail: (e) ->
		$target = $(e.currentTarget)
		id = $target.data().uw
		$target.toggleClass "active"
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
	playAudio: (e) ->
		src = "http://tts.yeshj.com/uk/s/" + encodeURIComponent(@item.title)
		Member.playSound(src)
		this

module.exports = CardItem
