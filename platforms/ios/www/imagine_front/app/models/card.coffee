AjaxCard = require("models/ajax_card")
Member = require("models/member")
class Card extends Spine.Model
	@configure 'Card', 'title', 'content', 'image', "_id", "audio", "sentence", "synset", "sync_over", "image_url"
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
	@check_unSync: ->
		@findAllByAttribute "sync_over",false
	@export_all: ->
		# TO-DO
		# find all image url and download to local
		this
	@fetch_new: ->
		# TO-DO
		# new week get new missions
		@export_all()
		@clean()
		@fetch()
		this
	from_network: ->
		request_url = Spine.Model.host + "/api/cards/collection"
		params =
			uuid: device.uuid
			id: @_id
		$.get request_url,params,(data) ->
			console.log data.data
	sync: (b64) ->
		blob = dataURLtoBlob(b64)
		form = new FormData()
		form.append("image", blob)
		form.append("_id",@_id)
		form.append("uuid",device.uuid)
		request_url = Spine.Model.host + "/api/cards/create"
		$.ajax
			type: 'POST'
			url: request_url
			data: form
			contentType: false
			processData: false
			error: =>
				@updateAttributes
					sync_over: false
			success: (d) =>
				if d.status is 0
					img_url = Spine.Model.host + d.data
					@updateAttributes
						sync_over: true
						image_url: img_url
module.exports = Card
