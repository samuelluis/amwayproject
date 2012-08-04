class Ability
  include CanCan::Ability
  require 'generator'

  def initialize(user)
    cannot :manage, :all
    can :access, :rails_admin
    can :dashboard
    can :generator
    cannot :history
    #can :manage, MemberModel, :member_id => user.member.id
    #can :manage, Model, :parent_id => user.member.id
    can :manage, User, :id => user.id
    can :manage, Person, :id => user.member.get_tree.map{|m| m.person.id}
    can :manage, Member, :id => (user.member.get_tree+[user.member]).map{|m| m.id}
  end
end
