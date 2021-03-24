# Preview all emails at http://localhost:3000/rails/mailers/open_forum_mailer
class OpenForumMailerPreview < ActionMailer::Preview
  def new_open_forum_email
    # Set up a temporary order for the preview
    question = "This is a sample question"
    method = "Please email me at jane@doe.com"

    OpenForumMailer.with(question: question, response_method: method).new_open_forum_email
  end
end
