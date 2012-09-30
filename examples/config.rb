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
  config.to_prepare do |file|
    cart.group = "TEST"

    notify 'alban@tryphon.eu', :by => :email
  end
end
