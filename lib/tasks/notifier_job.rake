namespace :notifier_job do

  desc "process notifications"
  task :process => :environment do
    notifications = Notification.where(:status => "active").where(:send_on < Date.now)
    notifications.each do |notification|
      notification.process_all
    end
  end
end