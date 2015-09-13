class BorrowerMailer < ApplicationMailer
  default from: "notifications@keevahh.com"

  def project_contributed_to(user, project_title)
    @user = user
    @project_title = project_title
    @url = "http://scale-it-up.herokuapp.com"
    mail(to: @user.email, subject: "Your project has been contributed to!")
  end
end
