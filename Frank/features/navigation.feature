Feature: Navigating Between Screens

Scenario: Moving from the initial 'Shift' screen to the 'Client' screen and 'Schedule' screen
Given I launch the app
Then I should be on the "Shift" screen

When I navigate to tab "Client"
Then I should be on the "Client" screen

When I navigate to tab "Schedule"
Then I should be on the "Schedule" screen


