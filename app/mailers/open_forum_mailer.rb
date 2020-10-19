class OpenForumMailer < ApplicationMailer
  def new_open_forum_email
    @question = params[:question]
    @response_method = params[:method]

    mail(to: Rails.application.credentials[:email][:system][:username], subject: "[ASPC Open Forum] New message!")
  end
end
