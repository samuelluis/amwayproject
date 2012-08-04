class Ability
  include CanCan::Ability
  require 'generator'

  def initialize(user)
    user ||= User.new
    can :access, :rails_admin
    if(!user.new_record?)
      can :dashboard
      can :generator
      cannot :history
      #can :manage, MemberModel, :member_id => user.member.id
      #can :manage, Model, :parent_id => user.member.id
      can :manage, User, :id => user.id
      can :manage, Person, :id => user.member.get_tree.map{|m| m.person.id}
      can :manage, Member, :id => (user.member.get_tree+[user.member]).map{|m| m.id}
    else
      can :dashboard
      can :create, Member
      can :create, Person
      can :create, User
    end
  end
end
