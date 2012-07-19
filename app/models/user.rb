class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :person_id, :person
  
  has_one :member
  has_one :person, :through => :member
  
  def name
    if self.person.nil?
      "#{self.email}"
    else
      "#{self.person.name} #{self.person.last_name}"
    end
  end
  
end
