class Member < ActiveRecord::Base
  belongs_to :parent, :class_name => "Member"
  belongs_to :person
  has_one :user
  
  has_many :members, :foreign_key => "parent_id"
  has_many :models, :foreign_key => "parent_id"
  has_many :member_models

  attr_accessor :current_model
  attr_accessible :person, :person_attributes, :name, :code, :parent, :parent_id, :members, :member_ids, :user, :current_model

  accepts_nested_attributes_for :person, :allow_destroy => true
  
  def name
    if self.person.nil?
      "#{self.class.name} ##{self.id}"
    else
      "#{self.person.name} #{self.person.last_name}"
    end
  end

  def get_tree
    self.members+(self.members.map{|m| m.get_tree}.flatten!||[])
  end

  def per_point
    point_value = 2.050
    dollar_rate = 42.45
    (point_value*dollar_rate)/0.7
  end

  def bonus_table
    {
      100 => 3,
      300 => 6,
      600 => 9,
      1000 => 12,
      1500 => 15,
      2500 => 18,
      4000 => 21,
      6000 => 23,
      7500 => 25
    }
  end

  def points
    return current_model.parent_points if current_model && !current_model.new_record? && current_model.parent_id == self.id
    return self.member_models.where(:model_id => current_model.id).first.points if current_model && !current_model.new_record?
    return 300
  end

  def bv
    (self.points*per_point).to_i
  end

  def group_bv
    sum = 0
    self.members.each do |m|
      m.current_model = self.current_model
      sum += m.pv if current_model.member_ids.include?(m.id)
    end
    (sum*per_point).to_i
  end

  def pv
    sum = 0
    self.members.each do |m|
      m.current_model = self.current_model
      sum += m.pv if current_model.member_ids.include?(m.id)
    end
    sum+self.points
  end

  def bonus
    before_key = nil
    bonus_table.keys.each do |k|
      if self.pv <= k
        return bonus_table[before_key.to_i].to_i
      end
      before_key = k
    end
  end

  def ibo_profit
    35
  end

  def sales_profit
    bv*(ibo_profit.to_f/100)
  end

  def bonus_total
    bv*(bonus.to_f/100)
  end

  def total
    bonus_total+sales_profit
  end
  
end
