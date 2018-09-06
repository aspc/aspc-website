# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create(
    :email => "dev_user@pomonastudents.org",
    :first_name => "dev_user",
    :is_cas_authenticated => false,
    :is_admin => true,
    :school => :pomona,
)