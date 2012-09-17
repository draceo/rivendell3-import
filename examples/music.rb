Rivendell::Import.config do |config|
  config.to_prepare do |file|
    cart.group = "MUSIC"
  end
end
