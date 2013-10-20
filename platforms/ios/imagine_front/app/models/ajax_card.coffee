class AjaxCard extends Spine.Model
	@configure 'Card', 'title', 'content', 'raw_content', 'pos', 'image', "_id", "audio", "sentence", "synset", "lat", "lng", "altitude", "cap_at", "group"
	@extend Spine.Model.Ajax
	@scope: "api"
	# @fromJSON: (json) ->
		# super([].concat data...)
	@ajaxQueue: (params) ->
		jqXHR    = null
		deferred = $.Deferred()
		promise  = deferred.promise()
		return promise unless Spine.Ajax.enabled

		request = (next) ->
			jqXHR = $.ajax(params).done(deferred.resolve).fail(deferred.reject).then(next, next)

		promise.abort = (statusText) ->
			return jqXHR.abort(statusText) if jqXHR
			index = $.inArray(request, Spine.Ajax.queue())
			Spine.Ajax.queue().splice(index, 1) if index > -1
			deferred.rejectWith(
				settings.context or settings,
				[promise, statusText, '']
			)
			promise
		Spine.Ajax.queue request
		promise
module.exports = AjaxCard
