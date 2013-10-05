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
	@checkConnection: ->
		networkState = navigator.connection.type
		states = {}
		states[Connection.UNKNOWN]  = 'Unknown connection'
		states[Connection.ETHERNET] = 'Ethernet connection'
		states[Connection.WIFI]     = 'WiFi connection'
		states[Connection.CELL_2G]  = 'Cell 2G connection'
		states[Connection.CELL_3G]  = 'Cell 3G connection'
		states[Connection.CELL_4G]  = 'Cell 4G connection'
		states[Connection.CELL]     = 'Cell generic connection'
		states[Connection.NONE]     = 'No network connection'
		console.log states[networkState]
module.exports = Member
