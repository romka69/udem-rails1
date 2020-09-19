user = User.create!(email: "a@a.a", password: "123456", password_confirmation: "123456")

30.times do
  Course.create!([{
                      title: Faker::Educator.course_name,
                      description: Faker::TvShows::GameOfThrones.quote,
                      user_id: user.id
                  }])
end