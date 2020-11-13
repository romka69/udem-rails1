# Preview all emails at http://localhost:3000/rails/mailers/enrollment_mailer
class EnrollmentMailerPreview < ActionMailer::Preview
  def new_enrollment_student
    EnrollmentMailer.new_enrollment_student(Enrollment.first).deliver_now
  end

  def new_enrollment_teacher
    EnrollmentMailer.new_enrollment_teacher(Enrollment.first).deliver_now
  end
end
