RailsAdmin.config do |config|
  
  config.total_columns_width = 900
  config.current_user_method { current_user }

  config.main_app_name = ['Amway Project', 'Admin']
  config.authorize_with :cancan
  
  config.model Member do
  	list do
  	  field :name
  	  field :code
  	  field :parent
  	  field :members
	  end
  end
end