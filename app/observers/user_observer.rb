# To change this template, choose Tools | Templates
# and open the template in the editor.

class UserObserver < ActiveRecord::Observer
  def after_create(user)
    user.profile = Profile.create
  end
end
