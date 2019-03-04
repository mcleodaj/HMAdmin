users = [
  {username: 'hmadmin', password: 'FgfjGZZM5Fn6m9dy'},
]

users.each do |u|
  User.create(u)
end