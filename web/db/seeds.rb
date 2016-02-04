email = 'admin@pieoneers.com'
password = 'jiAw3oL7I4Vus1eck8Vi'

admin = User.create! email: email, password: password, name: 'IPS Admin', admin: true
admin.product_list = ProductList.create

puts "Admin credentials: #{email} / #{password}.".on_blue
puts "Don't forget to add products to admin's product list.".on_blue
