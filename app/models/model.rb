class Model < ActiveRecord::Base
  belongs_to :parent, :class_name => "Member"
  
  has_many :member_models
  has_many :members, :through => :member_models

  scope :by_date, lambda{ |date| where(:model_date => ((date-(date.day-1).days)..((date+1.month)-date.day.days))) }
end
