namespace :log do
  desc 'This task is called by the Heroku scheduler add-on'
  task due_date: :environment do
    Log.create_due_date_notification_logs!
  end
end
