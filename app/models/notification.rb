class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :receipients
  
  def contacts
    current_contacts = []
    receipients.each do |el|
      current_contacts << el.contact
    end
    return current_contacts
  end
  
  def get_email_by_phonenumber(phonenumber) 
    result = ''
    phonenumber.gsub!("+", "")
    phonenumber.gsub!(" ", "")
    phonenumber.gsub!("-", "")
    phonenumber = phonenumber[1..phonenumber.length - 1] if phonenumber.start_with?('3')
    phonenumber = phonenumber[1..phonenumber.length - 1] if phonenumber.start_with?('8')
    code = phonenumber[0..2]
    p code
    case code
    when '067','096', '097', '098':
        result = '38' + phonenumber + '@2sms.kyivstar.net'      
    end
    
    return nil if result == ''
    return result
    
  end
  
  def process_all    
    process_emails
    process_free_sms
  end
  
  def process_emails
    
    receipients.each do |el|
      if(el.contact.email && el.contact.send_email)
        mail = Notifier.basic_message(el.contact.email, subject, body) 
        mail.deliver                    # sends the email
      end
    end
  end  
  
  def process_free_sms    
    receipients.each do |el|
      email_address = get_email_by_phonenumber(el.contact.phonenumber)
      if(email_address && el.contact.send_sms && el.contact.only_free_sms)
        mail = Notifier.basic_message(email_address, subject, sms_body)  # => a Mail::Message object
        mail.deliver                    # sends the email
      end
    end
  end
end
