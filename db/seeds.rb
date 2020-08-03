# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Cat.destroy_all

cat1 = Cat.create!(birth_date: '24/12/2018', color: 'black', name: 'Gizmo', sex: 'M', description: 'Gizmo is the luckiest black cat ever!')
cat2 = Cat.create!(birth_date: '11/02/2015', color: 'white', name: 'Spots', sex: 'F', description: 'Her Mom is always pampering her')
cat3 = Cat.create!(birth_date: '16/04/2020', color: 'brown', name: 'Chatoran', sex: 'M', description: 'This kitten is the cutest you will ever meet')