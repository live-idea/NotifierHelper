class Notifier < ActionMailer::Base
  default :from => "from@example.com"
  #   default :from => 'no-reply@example.com',
  #         :return_path => 'system@example.com'
  #
  #def welcome(recipient)
  #  @account = recipient
  #  mail(:to => recipient.email_address_with_name,
  #       :bcc => ["bcc@example.com", "Order Watcher <watcher@example.com>"])
  #  end
  def basic_message(recipient, subject, message)
    @account = recipient
    mail(:subject => subject,
      :to => [recipient],
      :from => 'no-reply@yourdomain.com',
      :body => [message],
      :content_type => "text/plain",
      :mime_version => '1.1'
    )
  end

  
end
