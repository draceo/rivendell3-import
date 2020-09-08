#   Mail.defaults do
#     delivery_method :smtp, { :address              => "smtp.example.com",
#                              :port                 => 587,
#                              :domain               => 'your.host.name',
#                              :user_name            => '<username>',
#                              :password             => '<password>',
#                              :authentication       => 'plain',
#                              :enable_starttls_auto => true  }
#   end

Mail.defaults do
  delivery_method :smtp, { :address => "smtp.example.com" }
end

# Rivendell3::API::Xport.debug_output $stdout

Rivendell3::Import::Notifier::Mail.from = "rd-notifications@example.com"

Rivendell3::Import.config do |config|
  config.rivendell.host = "localhost"
  config.rivendell.login_name = "user"
  config.rivendell.password = ""

  config.to_prepare do |file|
    # task.cancel!

    cart.default_title = file.basename

    file.in("music") do
      cart.group = "MUSIC"
    end

    file.in("pad") do
      name = file.basename
      if name.match /-lundi$/
        cart.cut.days = %w{mon}
        name.gsub! /-lundi$/, ""
      end

      cart.clear_cuts!
      cart.find_by_title name
      cart.cut.description = file.basename
    end

    cart.group ||= "TEST"

    # To delete file when task is completed
    #task.delete_file!

    # notify 'prog@example-radio.com', :by => :email
  end
end
