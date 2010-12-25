class Receipient < ActiveRecord::Base
  belongs_to :contact
  belongs_to :notification
  
    
  def fullname
    "#{contact.firstname} #{contact.lastname}"
  end
end
