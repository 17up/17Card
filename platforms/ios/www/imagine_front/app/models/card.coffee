AjaxCard = require("models/ajax_card")
class Card extends Spine.Model
	@configure 'Card', 'title', 'content', 'image', "_id", "audio", "sentence", "synset", "sync_over", "image_url", "lat", "lng", "altitude", "cap_at"
	@extend Spine.Model.Local
	@fetch: ->
		# @clean()
		if localStorage[@className]
			super()
		else
			AjaxCard.fetch
				data: "uuid=#{device.uuid}"
				complete: (e) =>
					if e.responseJSON.status is 0
						@records = AjaxCard.all()
						@change()
						@refresh(@all(), clear: true)
	@clean: ->
		localStorage[@className] = []
	@unSync: ->
		@findAllByAttribute "sync_over", false
	@unComplete: ->
		@findAllByAttribute "image", "./trans.png"
	@exportAll: ->
		# TO-DO
		# find all image url and download to local
		this
	@fetchNew: ->
		# TO-DO
		# new week get new missions
		@export_all()
		@clean()
		@fetch()
		this
	collection: ->
		request_url = Spine.Model.host + "/api/cards/collection"
		params =
			uuid: device.uuid
			id: @_id
		$.get request_url,params,(data) ->
			console.log data.data
	sync: ->
		blob = dataURLtoBlob(@image)
		form = new FormData()
		form.append("image", blob)
		form.append("lat", @lat) if @lat
		form.append("lng", @lng) if @lng
		form.append("altitude", @altitude) if @altitude
		form.append("cap_at", @cap_at || new Date())
		form.append("_id",@_id)
		form.append("uuid",device.uuid)
		request_url = Spine.Model.host + "/api/cards/create"
		AjaxCard.ajaxQueue(
			type: 'POST'
			url: request_url
			data: form
			contentType: false
			processData: false
		).done(@syncSuccess).fail(@syncFail)
	syncSuccess: (d) =>
		if d.status is 0
			img_url = Spine.Model.host + d.data
			@updateAttributes
				sync_over: true
				image_url: img_url
	syncFail: (err) =>
		console.log err
		@updateAttributes
			sync_over: false
		@trigger "badge:refresh"

module.exports = Card
