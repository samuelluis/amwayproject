class Person < ActiveRecord::Base
	has_one :member
	has_one :user, :through => :member
end
