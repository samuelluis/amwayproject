# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Member.create(:code => "000", :points => 300, :person => Person.new(:name => "Leandro", :last_name => "Fondeur"), :user => User.new(:email => "leandro@amway.com", :password => "password"))
Member.create(:code => "001", :points => 300, :person => Person.new(:name => "Samuel", :last_name => "Luis De La Cruz"), :user => User.new(:email => "samuel@amway.com", :password => "password"), :parent_id => 1)
Member.create(:code => "002", :points => 300, :person => Person.new(:name => "Jinette", :last_name => "Lizardo"), :user => User.new(:email => "jinette@amway.com", :password => "password"), :parent_id => 1)
Member.create(:code => "003", :points => 300, :person => Person.new(:name => "Wagnel", :last_name => "Cuello"), :user => User.new(:email => "wagnel@amway.com", :password => "password"), :parent_id => 1)
Member.create(:code => "011", :points => 300, :person => Person.new(:name => "Adonis", :last_name => "Luis De La Cruz"), :parent_id => 2)
Member.create(:code => "012", :points => 300, :person => Person.new(:name => "Margarita", :last_name => "De La Cruz"), :parent_id => 2)
Member.create(:code => "013", :points => 300, :person => Person.new(:name => "Joel Abraham", :last_name => "Espinal Carrazco"), :parent_id => 2)
Member.create(:code => "021", :points => 300, :person => Person.new(:name => "Sandy", :last_name => "Ramirez"), :parent_id => 3)
Member.create(:code => "022", :points => 300, :person => Person.new(:name => "Jonathan", :last_name => "German"), :parent_id => 3)
Member.create(:code => "023", :points => 300, :person => Person.new(:name => "Ruben", :last_name => "Mancebo Rodriguez"), :parent_id => 3)
Member.create(:code => "031", :points => 300, :person => Person.new(:name => "Claribel", :last_name => "Eucebio"), :parent_id => 4)
Member.create(:code => "032", :points => 300, :person => Person.new(:name => "Sandy", :last_name => "Rafael"), :parent_id => 4)
Member.create(:code => "033", :points => 300, :person => Person.new(:name => "Leonel", :last_name => "Fria"), :parent_id => 4)