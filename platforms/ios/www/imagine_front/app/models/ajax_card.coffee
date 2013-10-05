class AjaxCard extends Spine.Model
	@configure 'Card', 'title', 'content', 'image', "_id", "audio", "sentence", "synset"
	@extend Spine.Model.Ajax
	@scope: "api"
	@fromJSON: (json) ->
		data = for item in json.data
			if item.image
				src = Spine.Model.host + item.image
			else
				src = "./trans.png"
			options =
				audio: "http://tts.yeshj.com/uk/s/" + encodeURIComponent(item.title)
				image: src

			$.extend {},item,options
		super data
module.exports = AjaxCard
