Feature: Manage Cart attributes
  In order to organize dropboxes
  An user
  wants to filter files by name
  
  Scenario: Select a file by Ruby regexp
    Given a configuration with this prepare block 
     """
     if file.match /dummy/
       task.tags << 'matched'
     end
     """ 
    When a file "dummy.wav" is imported   
    Then the task should have tag "matched"

  Scenario: Select a file with helper 'with'
    Given a configuration with this prepare block 
     """
     with /dummy/ do
       task.tag 'matched'
     end
     """ 
    When a file "dummy.wav" is imported   
    Then the task should have tag "matched"
