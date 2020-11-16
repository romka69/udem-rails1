LANGUAGES = %w[English Russian]
LEVELS = %w[Beginner Intermediate Advanced]
TAGS = %w[Ruby Vue Ubuntu Web Docker Css Skills HTML C++ Work Design Classwork DIY]

user_admin = User.new(email: "admin@a.a", password: "123456", password_confirmation: "123456")
user_admin.skip_confirmation!
user_admin.save!

user_teacher = User.new(email: "teacher@t.t", password: "123456", password_confirmation: "123456")
user_teacher.skip_confirmation!
user_teacher.save!

user_student = User.new(email: "student@s.s", password: "123456", password_confirmation: "123456")
user_student.skip_confirmation!
user_student.save!

PublicActivity.enabled = false

def image_fetcher
  URI.open("https://robohash.org/sitsequiquia.png?size=300x300&set=set#{rand(1..5)}")
end

def tags_adder
  handler = []
  rand(2..4).times { handler << Tag.all.sample.id }
  handler
end

def course_creator(n, user, paid = false)
  price = paid == false ? 0 : Faker::Number.between(from: 5, to: 100)
  course = Course.new({
                          title: Faker::Educator.course_name,
                          description: Faker::Books::Lovecraft.paragraph,
                          user: user,
                          short_description: Faker::Quote.famous_last_words,
                          language: LANGUAGES.sample,
                          level: LEVELS.sample,
                          price: price,
                          tag_ids: tags_adder,
                          published: true,
                          approved: true,
                      })
  course.logo.attach({
                        io: image_fetcher,
                        filename: "#{n}_faker_image.jpg"
                     })
  course.save!
end

def lesson_creator(course_id)
  rand(3..6).times do
    lesson = Lesson.create!({
                               title: Faker::TvShows::GameOfThrones.unique.city,
                               content: Faker::Books::Lovecraft.sentence(word_count: 3),
                               course_id: course_id
                             })

    comment_creator(lesson.id)
  end

  Faker::TvShows::GameOfThrones.unique.clear
end

def comment_creator(lesson_id)
  user_id = User.find_by(email: "student@s.s").id

  rand(1..2).times do
    Comment.create!({
                       content: Faker::TvShows::HeyArnold.quote,
                       user_id: user_id,
                       lesson_id: lesson_id
                    })
  end
end

TAGS.each { |tag| Tag.create!({ name: tag }) }

# generate free courses
6.times do |n|
  course_creator(n, user_teacher)
end

# generate paid courses
3.times do |n|
  course_creator(n, user_teacher, true)
end

Course.where(price: 0).each do |course|
  lesson_creator(course.id)

  Enrollment.create!({
                         course_id: course.id,
                         user_id: User.find_by(email: "student@s.s").id,
                         rating: rand(3..5),
                         review: Faker::Quotes::Shakespeare.hamlet_quote,
                         price: course.price
                     })
end

if Rails.application.credentials.dig(:seed_password).present?
  User.all.each do |user|
    user.password = Rails.application.credentials.dig(:seed_password)
    user.save!
  end
end

PublicActivity.enabled = true
