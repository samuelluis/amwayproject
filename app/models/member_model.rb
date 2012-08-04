class MemberModel < ActiveRecord::Base
  belongs_to :member
  belongs_to :model
end
