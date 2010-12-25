class Group < ActiveRecord::Base
  validates :name, :description, :presence => true
  belongs_to :user
  has_and_belongs_to_many :contacts
end
