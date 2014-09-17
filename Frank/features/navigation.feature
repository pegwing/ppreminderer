Feature: Navigating Between Screens. Each screen is available via a tab button.

Scenario: Moving between the 'Shift' screen to the 'Client' screen and 'Schedule' screen
  Given I launch the app
   Then I should see the tab button "Client"
   Then I should see the tab button "Schedule"
   Then I should see the tab button "Shift"

   When I navigate to the tab "Shift"
   Then I should be on the "Shift" screen

   When I navigate to the tab "Client"
   Then I should be on the "Client" screen

   When I navigate to the tab "Schedule"
   Then I should be on the "Schedule" screen

   When I navigate to the tab "Schedule"
   Then I should be on the "Schedule" screen


Scenario: The selected screen should be preserved across restarts of the application
  Given I launch the app
   When I navigate to the tab "Shift"
   Then I should be on the "Shift" screen
  Given I press home on simulator
   Then I should be on the "Shift" screen
   When I navigate to the tab "Client"
   Then I should be on the "Client" screen
  Given I press home on simulator
   Then I should be on the "Client" screen
   When I navigate to the tab "Schedule"
   Then I should be on the "Schedule" screen
  Given I press home on simulator
   Then I should be on the "Schedule" screen

