user_admin = User.new(email: "a@a.a", password: "123456", password_confirmation: "123456")
user_admin.skip_confirmation!
user_admin.save!

user_teacher = User.new(email: "t@t.t", password: "123456", password_confirmation: "123456")
user_teacher.skip_confirmation!
user_teacher.save!

user_student = User.new(email: "s@s.s", password: "123456", password_confirmation: "123456")
user_student.skip_confirmation!
user_student.save!
user_student.remove_role(:teacher)

10.times do
  Course.create!([{
                      title: Faker::Educator.course_name,
                      description: Faker::TvShows::GameOfThrones.quote,
                      user: user_teacher,
                      short_description: Faker::Quote.famous_last_words,
                      language: Faker::ProgrammingLanguage.name,
                      level: "Beginner",
                      price: Faker::Number.between(from: 1000, to: 20000)
                  }])
end