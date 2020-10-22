class OpenForumMailer < ApplicationMailer
  def new_open_forum_email
    @question = params[:question]
    @response_method = params[:response_method]
    @to = params[:to]

    mail(to: @to, subject: "[ASPC Open Forum] New message!")
  end
end
