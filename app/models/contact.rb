class Contact < ActiveRecord::Base
  validate :firstname, :presence => true, :message => 'Not valid'
  belongs_to :user
  has_and_belongs_to_many :groups
  has_many :receipient, :dependent => :destroy
  cattr_reader :per_page
  @@per_page = 10
  
  def fullname
    "#{firstname} #{lastname}"
  end

end
