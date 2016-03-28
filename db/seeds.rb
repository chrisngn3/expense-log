# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


chris = User.create name: 'Chris', amount_paid: 0.0, owe: {}
myron = User.create name: 'Myron', amount_paid: 0.0, owe: {}
stephen = User.create name: 'Stephen', amount_paid: 0.0, owe: {}