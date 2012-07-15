$(function() {
    $('div.circle').mouseover(function() {
        $(this).find('div.outer-circle').addClass('hover');
        $(this).find('div.middle-circle').addClass('hover');
    });
    $('div.circle').mouseout(function() {
        $(this).find('div.outer-circle').removeClass('hover');
        $(this).find('div.middle-circle').removeClass('hover');
    });
	center();
});

function center(){
	$("table.circles").each(function(){
		if($(this).children("tbody").children("tr").length>1){
			var members = $(this).children("tbody").children("tr:last").children("td").length;
			$(this).children("tbody").children("tr:first").children("td:first").attr("colspan", members+"");
		}
	});
}