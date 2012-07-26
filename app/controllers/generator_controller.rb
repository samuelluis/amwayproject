class GeneratorController < ApplicationController
  
  layout 'generator'
  def index
    
  end

  def generator

  end

  def get_members
  	parent = Member.find(params[:id].to_i)
  	members = parent.members.map{ |m| "<td><table class='circles'><tr class='parent'><td>"+render_to_string(:partial => "generator/circle", :locals => { :member => m })+"</td></tr><tr class='members'></tr></table></td>" }
  	render :text => members.join("<td class='empty'>&nbsp;</td>").html_safe
  end
end
