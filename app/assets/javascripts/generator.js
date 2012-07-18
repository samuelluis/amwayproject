var $ = jQuery.noConflict();
var active = null;
var paper = null;
var lines = new Array();
var confirmation = "";
$(function() {
	if($("div#member_form").length>0){
		confirmation = $("#confirm p").html();
		paper = Raphael(0, 0, 0, 0);
		$("svg").css("height","100%").css("width","100%");
		addCircleAnimation("div.circle");
		addFlashTitle('.flash');
		center();
		bindMembers();
		makeDialog();
	}
});

function addCircleAnimation(element){
    $(element).mouseover(function() {
        $(this).find('div.outer-circle').addClass('hover');
        $(this).find('div.middle-circle').addClass('hover');
		$(this).find('div.middle-circle .action-circle').addClass('hover');
    });
    $(element).mouseout(function() {
        $(this).find('div.outer-circle').removeClass('hover');
        $(this).find('div.middle-circle').removeClass('hover');
		$(this).find('div.middle-circle .action-circle').removeClass('hover');
    });
}

function addFlashTitle(element){
	var title = "";
    $(element).mouseover(function(e) {
		title = $(this).attr("title");
		$(this).removeAttr("title");
		$("#flash").html(title);
		$("#flash").css("top",(e.pageY-40)+"px").css("left",(e.pageX)+"px");
		$("#flash").addClass("hover");
    });
    $(element).mouseout(function() {
		$(this).attr("title", title);
		$("#flash").removeClass("hover");
		$("#flash").html("");
		$("#flash").css("top","0px").css("left","0px");
    });
}

function makeDialog() {
	$("#dialog:ui-dialog").dialog("destroy");
	var code = $("#code"),
		name = $("#name"),
		last_name = $("#last_name"),
		parent_id = $("#parent_id"),
		allFields = $([]).add(code).add(name).add(last_name).add(parent_id),
		tips = $(".validateTips");
	function updateTips(t) {
		tips.text(t).addClass("ui-state-highlight");
		setTimeout(function(){tips.removeClass( "ui-state-highlight", 1500 );}, 500);
	}
	function check(o, n) {
		if(o.val().length <= 0){
			o.addClass("ui-state-error");
			updateTips("Field "+n+" cannot be empty.");
			return false;
		}
		return true;
	}
	$("#member_form").dialog({
		autoOpen: false,
		height: 300,
		width: 400,
		modal: true,
		buttons: {
			"Save": function() {
				var bValid = true;
				allFields.removeClass("ui-state-error");
				bValid = bValid && check(code, "code");
				bValid = bValid && check(name, "name");
				bValid = bValid && check(last_name, "last name");
				if (bValid) {
					if($("#member_form #id").val()=="0"){
						var parent = active.parents("tr.parent:first");
						var members = active.parents("tr.parent:first").next("tr.members");
						var text = "";
						if(members.html()!="")
							text += "<td class='empty'>&nbsp;</td>";
						text += "<td><table class='circles'><tr class='parent'>"+parent.html()+"</tr><tr class='members'></tr></table></td>";
						var member = $(text);
						var form = $(member).find("div.circle:first");
						var data = form.children("div.data");
						id = "new_0";
						form.attr("id", "member_"+id);
						form.find("span.member").html(name.val()+" "+last_name.val());
						//form.find("span.points").html("300");
						data.children("input.id").val(id);
						data.children("input.code").val(code.val());
						data.children("input.name").val(name.val());
						data.children("input.last_name").val(last_name.val());
						data.children("input.parent_id").val(data.children("input.id").val());
						members.append(member);
						addFlashTitle(form.find('.flash'));
						addCircleAnimation(form);
					}
					else{
						var form = active.parents("div.circle:first");
						var data = form.children("div.data");
						
						form.find("span.member").html(name.val()+" "+last_name.val());
						//form.find("span.points").html("300");
						data.children("input.code").val(code.val());
						data.children("input.name").val(name.val());
						data.children("input.last_name").val(last_name.val());
					}
					$(this).dialog("close");
				}
			},
			Cancel: function() {
				$(this).dialog("close");
			}
		},
		close: function() {
			allFields.val("").removeClass("ui-state-error");
			$(".validateTips").show();
			$("#member_form input").removeAttr("disabled");
			$("#member_form").closest("div[aria-labelledby='ui-dialog-title-member_form']").find(".ui-dialog-buttonpane").find("button:last").find(".ui-button-text").html("Cancel");
			$("#member_form").closest("div[aria-labelledby='ui-dialog-title-member_form']").find(".ui-dialog-buttonpane button:first").show();
			active = null;
			center();
			bindMembers();
			$("input#id").val("0");
		}
	});
	
	$("#confirm").dialog({
		autoOpen: false,
		height: 200,
		width: 400,
		modal: true,
		buttons: {
			"Yes, I'm Sure": function() {
				active.parents("table.circles:first").parents("td:first").prev("td.empty").remove();
				active.parents("table.circles:first").parents("td:first").remove();
				active = null;
				center();
				bindMembers();
				$(this).dialog("close");
				$("#confirm p").html(confirmation);
			},
			Cancel: function() {
				$(this).dialog("close");
				$("#confirm p").html(confirmation);
				active = null;
			}
		}
	});
	
}

function bindMembers(){
	$("path").remove();
	$("table.circles").each(function(){
		if($(this).children("tbody").children("tr").length>1){
			var parent = $(this).children("tbody").children("tr:first").children("td:first");
			var pwidth = parent.width();
			var pheight = parent.height();
			var px = parent.position().left+(pwidth/2);
			var py = parent.position().top+(pheight/2);
			$(this).children("tbody").children("tr:last").children("td").each(function(){
				if(!$(this).hasClass("empty")){
					var member = $(this);
					if($(this).has("table")){
						member = $(this).children("table").children("tbody").children("tr:first").children("td");
					}
					var mwidth = member.width();
					var mheight = member.height();
					var mx = member.position().left+(mwidth/2);
					var my = member.position().top+(mheight/2);
					lines.push(paper.path("M"+px+" "+py+"L"+mx+" "+my));
				}
			});
		}
	});
}

function center(){
	$("table.circles").each(function(){
		if($(this).children("tbody").children("tr").length>1){
			var members = $(this).children("tbody").children("tr:last").children("td").length;
			$(this).children("tbody").children("tr:first").children("td:first").attr("colspan", members+"");
		}
	});
}

function addMember(target){
	active = $(target);
	$("#ui-dialog-title-member_form").html("Add Member");
	$("#member_form").dialog("open");
}

function removeMember(target){
	active = $(target);
	var form = $(target).parents("div.circle:first").children("div.data");
	var full_name = form.find("input.name").val()+" "+form.find("input.last_name").val();
	var texts = confirmation.split("?");
	$("#confirm p").html(texts[0]+" "+full_name+"?"+texts[1]);
	$("#confirm").dialog("open");
}

function editMember(target){
	active = $(target);
	loadFields(target);
	$("#ui-dialog-title-member_form").html("Edit Member");
	$("#member_form").dialog("open");
}

function showMember(target){
	loadFields(target);
	$(".validateTips").hide();
	$("#member_form input").attr("disabled","disabled");
	$("#member_form").dialog("open");
	$("#ui-dialog-title-member_form").html("Show Member");
	$("#member_form").closest("div[aria-labelledby='ui-dialog-title-member_form']").find(".ui-dialog-buttonpane").find("button:last").find(".ui-button-text").html("Close");
	$("#member_form").closest("div[aria-labelledby='ui-dialog-title-member_form']").find(".ui-dialog-buttonpane button:first").hide();
}

function loadFields(target){
	var id = $("#member_form #id");
	var code = $("#member_form #code");
	var name = $("#member_form #name");
	var last_name = $("#member_form #last_name");
	var parent_id = $("#member_form #parent_id");
	var form = $(target).closest("div.circle").children("div.data");
	id.val(form.find("input.id").val());
	code.val(form.find("input.code").val());
	name.val(form.find("input.name").val());
	last_name.val(form.find("input.last_name").val());
	parent_id.val(form.find("input.parent_id").val());
	return form;
}