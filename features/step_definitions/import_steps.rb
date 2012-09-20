def import
  @import ||= Rivendell::Import::Base.new.tap do |import|
    
  end
end

Given /^a configuration with this prepare block$/ do |code|
  import.to_prepare = eval  "lambda { |file| " + code + " }"
end

When /^a file "([^"]*)" is imported$/ do |file|
  import.file file
end

Then /^the task should have destination "([^"]*)"$/ do |destination|
  import.tasks.pop.destination.should == destination
end

Then /^the task should have tag "([^"]*)"$/ do |tag|
  import.tasks.pop.tags.should include(tag)
end
