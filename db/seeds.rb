# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

names = [
  'Games', 
  'Shopping',
  'Productivity',
  'Developer Tools', 
  'News & Weather',
  'Social'
]

skill_names = [
  'Rails',
  'Vue', 
  'React',
  'HTML',
  'CSS',
  'Javascript'
]

skills_list = []

skill_names.each do |skill|
  skills_list << Skill.create!(name: skill)
end

3.times do |i|

  user = User.create!(
    name: "User #{i}",
    img: "http://www.loftladderscotland.com/images/default_avatar.jpg",
    dev_bio: "Hey, I'm developer ##{i}",
    is_dev: true,
    dev_twitter: "https://twitter.com/piedpiperplc",
    dev_github: "https://github.com/chingu-voyages/v19-bears-team-07",
    dev_linkedin: "https://www.linkedin.com/in/rbranson/?originalSubdomain=vg",
    dev_portfolio: "https://github.com/chingu-voyages",
    email: "user#{i}@cool.com", 
    password: "password"
  )

  skills_list.each do |skill|
    user.skills << skill
  end

  category = Category.create!(name: names[i])

  app = App.create!(
    name: "App #{i}", 
    description: "An app description for App #{i}",
    img: "https://images-na.ssl-images-amazon.com/images/I/512EsSPL7KL._AC_UX679_.jpg",
    app_url: "https://myspace.com/",
    github_url: "https://github.com/chingu-voyages/v19-bears-team-07", 
    user: user,
    category: category
  )

  tag = Tag.create!(name: "Games #{i}", description: "This is fun", app: app)
  comment = Comment.create!(title: "comment #{i}", description: "This is a great app #{i}!", app: app, user: user)

end


