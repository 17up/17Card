class Member extends Spine.Model
	@configure 'Member', "_id",  'gems'
	@extend Spine.Model.Local
	@fetch: ->
		# @clean()
		if localStorage[@className]
			super()
		else
			request_url = Spine.Model.host + "/api/members"
			platform = device.platform + " " + device.version
			params =
				uuid: device.uuid
				name: device.model
				platform: platform
			$.get request_url,params, (data) =>
				@create data.data
				@refresh(data.data, clear: true)
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
	@recordMedia: (filename,uploadMedia) ->
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
				Member.request_media(filename + ".wav",uploadMedia)
		,1000)
	@request_media: (media_file,handler) ->
		onError = (error) ->
			console.log(error.code + error.message)
		onSuccess = (fileSystem) ->
			readDataUrl = (file) ->
				reader = new FileReader()
				reader.onloadend = (evt) ->
					handler evt.target.result
				reader.readAsDataURL(file)
			fail = (evt) ->
				console.log(evt.target.error.code)
			gotFile = (file) ->
				readDataUrl(file)
			gotFileEntry = (fileEntry) ->
				fileEntry.file(gotFile, fail)
			fileSystem.root.getFile(media_file, null, gotFileEntry, fail)
		requestFileSystem(LocalFileSystem.TEMPORARY, 0, onSuccess, onError)
module.exports = Member
