
// refs #

function xinspect(o,i){
    if(typeof i=='undefined')i='';
    if(i.length>50)return '[MAX ITERATIONS]';
    var r=[];
    for(var p in o){
        var t=typeof o[p];
        r.push(i+'"'+p+'" ('+t+') => '+(t=='object' ? 'object:'+xinspect(o[p],i+'  ') : o[p]+''));
    }
    return r.join(i+'\n');
}

$(document).ready(function(){
	$("input[data-select-toggle][type=checkbox]")
		.change(function () {
			box = $(this);
			area_id = box.attr("data-select-toggle");
			$("#" + area_id).toggle(box.is(":checked"));
		}).trigger('change')
	
	$("input[data-select-toggle][type=radio]")
		.change(function (e) {
			box = $(this);
			area_id = box.attr("data-select-toggle");
			$("#" + area_id).toggle(box.is(":checked"));
			if(e.isTrigger == undefined) {
			  $("input[name='" + box.attr("name") + "']:not([data-select-toggle=" + area_id + "])").trigger('change');
			}
		}).trigger('change')
});
