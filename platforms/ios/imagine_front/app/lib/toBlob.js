window.dataURLtoBlob = function(data) {
	var mimeString = data.split(',')[0].split(':')[1].split(';')[0];
	var byteString = atob(data.split(',')[1]);
	var ab = new ArrayBuffer(byteString.length);
	var ia = new Uint8Array(ab);
	for (var i = 0; i < byteString.length; i++) {
		ia[i] = byteString.charCodeAt(i);
	}
	var bb = (window.BlobBuilder || window.WebKitBlobBuilder || window.MozBlobBuilder);
	if (bb) {
		//    console.log('BlobBuilder');
		bb = new (window.BlobBuilder || window.WebKitBlobBuilder || window.MozBlobBuilder)();
		bb.append(ab);
		return bb.getBlob(mimeString);
	} else {
		//    console.log('Blob');
		bb = new Blob([ab], {
			'type': (mimeString)
		});
		return bb;
	}
}

