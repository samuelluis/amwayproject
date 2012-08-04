class GeneratorController < ApplicationController
  def save_model
    p = params
    if params[:_save]
      parent = Member.find(params[:parent_id].to_i)
      model = parent.models.by_date(Date.new(params[:year].to_i, params[:month].to_i)).first
      parent_points = params[:members]["#{parent.id}".to_sym][:member_model][:points].to_i if params[:members]["#{parent.id}".to_sym]
      model ||= Model.create(:parent => parent, :model_date => Date.new(params[:year].to_i, params[:month].to_i), :parent_points => params[:members]["#{parent.id}".to_sym][:member_model][:points].to_i)
      removed = params.delete(:remove)||[]
      members = params.delete(:members)||[]
      new_members = members.delete(:new)||[]

      removed.each do |id|
        MemberModel.where(:member_id => id.to_i, :model_id => model.id).first.destroy
        Member.find(id.to_i).destroy
      end

      members.each do |k, v|
        m = Member.find(k.to_i)
        m.parent_id = v[:parent_id]
        m.code = v[:code]
        mm = MemberModel.where(:member_id => m.id, :model_id => model.id).first
        mm ||= MemberModel.new(:member_id => m.id, :model_id => model.id)
        mm.points = v[:member_model][:points].to_i
        mm.save
        p = m.person
        p ||= Person.new
        p.name = v[:person][:name]
        p.last_name = v[:person][:last_name]
        p.save
        m.person_id = p.id
        m.save
      end

      new_ids = {}
      new_members.each do |k, v|
        m = Member.create(:code => v[:code], :person => Person.new(:name => v[:person][:name], :last_name => v[:person][:last_name]))
        new_ids[v[:id].to_sym] = {:id => m.id, :parent_id => v[:parent_id]}
        MemberModel.create(:member_id => m.id, :model_id => model.id, :points => v[:member_model][:points].to_i)
      end

      new_ids.each do |k, v|
        Member.find(v[:id]).update_attributes(:parent_id => (new_ids[v[:parent_id].to_sym]) ? new_ids[v[:parent_id].to_sym][:id].to_i : v[:parent_id].to_i)
      end

      redirect_to "/admin/generator?id=#{model.id}", :id => model.id, :flash => {:success => "Model saved successfully."}
    end
    if params[:_load]
      model = Model.by_date(Date.new(params[:year].to_i, params[:month].to_i)).first
      if model
        redirect_to "/admin/generator?id=#{model.id}", :flash => {:success => "Model loaded successfully."}
      else
        redirect_to "/admin/generator", :flash => {:warning => "There isn't models for this month."}
      end
    end
  end
end
