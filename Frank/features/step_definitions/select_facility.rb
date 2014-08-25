When(/^I change facility from "(.*?)" to "(.*?)"$/) do |old_facility, new_facility|
    wait_for_element_to_exist_and_then_touch_it("view:'UIButton' marked:'#{old_facility}'")
    sleep 1
    wait_for_element_to_exist_and_then_touch_it("tableViewCell label marked:'#{new_facility}' parent tableViewCell")
end

Then /^I should see facility "(.*?)" selected$/ do |facility|
    check_element_exists("view:'UIButton' marked:'#{facility}")
end