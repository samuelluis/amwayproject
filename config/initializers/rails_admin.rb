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
  end
end