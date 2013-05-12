// Small script to collapse a box.
// It counts the clicks on the link inside a box and when
// it is clicked twice, the hash from the end of the url is
// removed and therefore the :target from the box.

var clicks = 0;
var name = "";
function changeBox(object) {
	
	if(clicks == 0){
		name = object.id
		clicks = 1
		document.getElementById("link"+name).href = ""
	}else{
		if(clicks == 1 && object.id == name){
			window.location.hash = "";
			document.getElementById("link"+name).href = "#"+name
			name = ""
			clicks = 0
		}else if(clicks == 1 && object.id != name){
			document.getElementById("link"+name).href = "#"+name
			name = object.id
			document.getElementById("link"+name).href = ""
		}
	}
}
