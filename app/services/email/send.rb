class Email::Send
  include Service

  attr_reader :sender, :recipients, :subject, :body, :object

  def initialize(from:, to:, subject:, body:, object: nil)
    @sender = from
    @recipients = to
    @subject = subject
    @body = body
    @object = object
  end

  def call
    Email.transaction do
      email = Email.create!(
        sender: sender,
        subject: subject,
        body: body,
        object: object
      )
      recipients.each do |recipient|
        EmailRecipient.create(email: email, recipient: recipient)
      end
    end
  end
end
