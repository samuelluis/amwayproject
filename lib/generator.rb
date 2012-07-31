require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class Generator < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        #register_instance_option :my_option do
        #  :default_value
        #end
        register_instance_option :root do
          true
        end
        register_instance_option :http_methods do
          [:get, :post]
        end
        register_instance_option :visible? do
          true
        end
      end
    end
  end
end