class Member < ActiveRecord::Base
  belongs_to :parent, :class_name => "Member"
  belongs_to :person
  belongs_to :user
  
  has_many :members, :foreign_key => "parent_id"
  
  def name
    if self.person.nil?
      "#{self.class.name} ##{self.id}"
    else
      "#{self.person.name} #{self.person.last_name}"
    end
  end
  
end
