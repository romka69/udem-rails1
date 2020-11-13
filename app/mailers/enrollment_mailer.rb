class EnrollmentMailer < ApplicationMailer
  def new_enrollment_student(enrollment)
    @enrollment = enrollment
    @course = @enrollment.course

    mail(to: @enrollment.user.email, subject: "You have enrolled to: #{@course}")
  end

  def new_enrollment_teacher(enrollment)
    @enrollment = enrollment
    @course = @enrollment.course

    mail(to: @enrollment.course.user.email, subject: "You have new student in: #{@course}")
  end
end
