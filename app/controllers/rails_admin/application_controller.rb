require 'rails_admin/abstract_model'

module RailsAdmin
  class ModelNotFound < ::StandardError
  end

  class ObjectNotFound < ::StandardError
  end

  class ApplicationController < ::ApplicationController
    newrelic_ignore if defined?(NewRelic)

    helper_method :_current_user, :_attr_accessible_role, :_get_plugin_name

    attr_reader :object, :model_config, :abstract_model

    before_filter do |c|
      puts "User: #{current_user}"
      if current_user.nil?
        redirect_to "/users/sign_in", :flash => {:warning => "Please customize your account by registering as Member to enjoy the Generator view."}
      elsif current_user.member.nil? && (c.request.path.split("/")[2] != "user" && c.request.path.split("/")[4] != "edit")
        redirect_to "/admin/user/#{current_user.id}/edit", :flash => {:warning => "Please customize your account by registering as Member to enjoy the Generator view."}
      end
    end

    before_filter :if => Proc.new{ |c| (c.request.path.split("/")[2] == "generator") } do
        @head_stylesheet_path = 'application.css'
    end

    def get_model
      @model_name = to_model_name(params[:model_name])
      raise RailsAdmin::ModelNotFound unless (@abstract_model = RailsAdmin::AbstractModel.new(@model_name))
      raise RailsAdmin::ModelNotFound if (@model_config = @abstract_model.config).excluded?
      @properties = @abstract_model.properties
    end

    def get_object
      raise RailsAdmin::ObjectNotFound unless (@object = @abstract_model.get(params[:id]))
    end

    def to_model_name(param)
      model_name = param.split("~").map(&:camelize).join("::")
    end

    private

    def _get_plugin_name
      @plugin_name_array ||= [RailsAdmin.config.main_app_name.is_a?(Proc) ? instance_eval(&RailsAdmin.config.main_app_name) : RailsAdmin.config.main_app_name].flatten
    end

    def _authenticate!
      instance_eval &RailsAdmin::Config.authenticate_with
    end

    def _authorize!
      instance_eval &RailsAdmin::Config.authorize_with
    end

    def _audit!
      instance_eval &RailsAdmin::Config.audit_with
    end

    def _current_user
      instance_eval &RailsAdmin::Config.current_user_method
    end

    alias_method :user_for_paper_trail, :_current_user

    def _attr_accessible_role
      instance_eval &RailsAdmin::Config.attr_accessible_role
    end

    rescue_from RailsAdmin::ObjectNotFound do
      flash[:error] = I18n.t('admin.flash.object_not_found', :model => @model_name, :id => params[:id])
      params[:action] = 'index'
      index
    end

    rescue_from RailsAdmin::ModelNotFound do
      flash[:error] = I18n.t('admin.flash.model_not_found', :model => @model_name)
      params[:action] = 'dashboard'
      dashboard
    end

    def not_found
      render :file => Rails.root.join('public', '404.html'), :layout => false, :status => :not_found
    end

    def rails_admin_controller?
      true
    end
  end
end
