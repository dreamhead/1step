When /^I am on the home page$/ do
  visit('/')  
end

Then /^I should see hello to "(.*?)" on home page$/ do |name|
  on_page_with :home do |page|
    page.should have_hello_to(name)
  end
end