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

  def tree
    parent = Member.find(params[:id].to_i)
    members = parent.members.map{ |m| "<td><table class='circles'><tr class='parent'><td>"+render_to_string(:partial => "generator/circle", :locals => { :member => m })+"</td></tr><tr class='members'></tr></table></td>" }
    members.join("<td class='empty'>&nbsp;</td>").html_safe
  end

  def get_tree
    self.members+(self.members.map{|m| m.get_tree}.flatten!||[])
  end

  def per_point
    124.316667
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

  def bv
    (self.points*per_point).to_i
  end

  def group_bv
    (self.members.sum{ |m| m.pv }*per_point).to_i
  end

  def pv
    self.points+self.members.sum{ |m| m.pv }
  end

  def bonus
    before_key = nil
    bonus_table.keys.each do |k|
      if self.points < k
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
