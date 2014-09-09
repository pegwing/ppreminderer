Feature: Select Facility

Scenario: Select Facility
Given I launch the app
Then I should be on the "Shift" screen
Then I should see facility "Group Home 1" selected

When I change facility from "Group Home 1" to "Group Home 2"
Then I should be on the "Shift" screen
Then I should see facility "Group Home 2" selected

