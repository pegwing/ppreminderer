#
#
Then(/^I should be on the "(.*?)" screen$/) do |screen_name|
  wait_for_element_to_exist "view:'UINavigationItemView' marked:'#{screen_name}'"
end

When(/^I navigate to the tab "(.*?)"$/) do |tab_name|
  
  touch "view:'UITabBarButton' marked:'#{tab_name}'"
end

When(/^I navigate to "(.*?)"$/) do |tab_name|
  wait_for_nothing_to_be_animating
  wait_for_element_to_exist_and_then_touch_it "navigationButton view marked:'#{tab_name}'"
end


Then(/^I should see the tab button "(.*?)"$/) do |tab_name|
    
    touch "view:'UITabBarButton' marked:'#{tab_name}'"
end

Given(/^I press home on simulator$/) do
    press_home_on_simulator
end
