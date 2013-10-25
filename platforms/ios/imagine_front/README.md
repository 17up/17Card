imagine card (17word) IOS Cordova 版本源码
=============

> spineJs + Jade + Stylus + Coffeescript

编译index.html `jade -P src/index.jade -o ../www/`

编译css,js `hem build`

具体编译路径见 slug.json

`scp 17word.ipa www@17up.org:~/17up/current/public/system/app/`

### Change Log

> 公开版本 v0.7 ／ 内部开发版本 v0.0.2

```
$("img.u_word").unveil 100, ->
			$(@).load ->
				@style.opacity = 1
		card.$el.find("img").trigger("unveil")
```

```
- var trans_image = "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"
.card_wraper
	.card_facade
		.title.lobster #{title}
		img.u_word(src = trans_image data-src = image)
		.empty_tip
			span.icon-camera
	.card_obverse
		.content #{content}
		ul.sentence
			each s in sentence
				li= s
```
