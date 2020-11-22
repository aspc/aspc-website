class OpenForumMailer < ApplicationMailer
  def new_open_forum_email
    @question = params[:question]
    @should_respond = params[:should_respond]
    @response_method = params[:response_method]
    @to = params[:to]

    mail(to: @to, subject: "[ASPC Contact Form] New message!")
  end
end
