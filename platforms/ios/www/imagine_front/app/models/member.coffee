class Member extends Spine.Model
	@configure 'Member', "_id",  'gems'
	@extend Spine.Model.Local
	@fetch: ->
		# @clean()
		if localStorage[@className]
			super()
		else
			@newer = true
			request_url = Spine.Model.host + "/api/members"
			platform = device.platform + " " + device.version
			params =
				uuid: device.uuid
				name: device.model
				platform: platform
			$.get request_url,params, (data) =>
				current = @create data.data
				@refresh(current, clear: true)
	@clean: ->
		localStorage[@className] = []
	# Connection.UNKNOWN
	# Connection.ETHERNET
	# Connection.WIFI
	# Connection.CELL_2G
	# Connection.CELL_3G
	# Connection.CELL_4G
	# Connection.CELL
	# Connection.NONE
	@checkConnection: (connection) ->
		navigator.connection.type is connection
	@playSound: (url) ->
		onSuccess = ->
			false
		onError = (error) ->
			console.log(error.code + error.message)
		sound = new Media(url,onSuccess, onError)
		sound.play()
	@recordMedia: (filename,$target,statClass = "recording") ->
		$target.addClass statClass
		onSuccess = ->
			false
		onError = (error) ->
			console.log(error.code + error.message)
		mediaRec = new Media(filename + ".wav",onSuccess,onError)
		mediaRec.startRecord()
		recTime = 0
		recInterval = setInterval(->
			recTime = recTime + 1
			if recTime >= 3
				clearInterval(recInterval)
				mediaRec.stopRecord()
				mediaRec.play()
				$target.removeClass statClass
		,1000)
module.exports = Member
