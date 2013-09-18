#   Mail.defaults do
#     delivery_method :smtp, { :address              => "smtp.me.com",
#                              :port                 => 587,
#                              :domain               => 'your.host.name',
#                              :user_name            => '<username>',
#                              :password             => '<password>',
#                              :authentication       => 'plain',
#                              :enable_starttls_auto => true  }
#   end

Mail.defaults do
  delivery_method :smtp, { :address => "smtp.free.fr" }
end

Rivendell::Import::Notifier::Mail.from = "root@tryphon.eu"

Rivendell::Import.config do |config|
  config.rivendell.host = "localhost"
  config.rivendell.login_name = "user"
  config.rivendell.password = ""

  config.to_prepare do |file|
    cart.default_title = file.basename

    file.in("music") do
      cart.group = "MUSIC"
    end

    file.in("pad") do
      cart.clear_cuts!
      cart.find_by_title file.basename
    end

    cart.group ||= "TEST"

    # To delete file when task is completed
    #task.delete_file!

    notify 'alban@tryphon.eu', :by => :email
  end
end
