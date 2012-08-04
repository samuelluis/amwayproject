RailsAdmin.config do |config|
  
  config.total_columns_width = 900
  config.current_user_method { current_user }

  config.main_app_name = ['Amway Project', 'Network Model Generator']
  config.authorize_with :cancan

  require 'generator'

  config.actions do
    # root actions
    dashboard                     # mandatory
    generator
    # collection actions 
    index                         # mandatory
    new
    export
    #history_index
    bulk_delete
    # member actions
    show
    edit
    delete
    #history_show
    #show_in_app
  end
  
  config.model Member do
  	list do
  	  field :name
  	  field :code
  	  field :parent
  	  field :members
	  end
    edit do
      field :name
      field :code
      field :parent
      field :person
    end
  end

  config.model User do
    list do
      field :person
      field :email
      field :member
    end
    edit do
      field :email
      field :password
      field :password_confirmation
      field :member
    end
  end

  config.model Person do
    list do
      field :name
      field :last_name
      field :member
      field :user
    end
    edit do
      field :name
      field :last_name
      field :member
    end
  end
end