When /^I am on the home page$/ do
  visit('/')  
end

Then /^I should see hello to "(.*?)" on home page$/ do |name|
  on_page_with :home do |page|
    page.should have_hello_to(name)
  end
end

When /^I am on the creation page$/ do
  visit('/edit')
end

When /^I create a record with the following detail:$/ do |detail|
  on_page_with :edit do |page_model|
    page_model.create_with(detail.hashes.first)
  end
end

When /^I am on the list page$/ do
  visit("/list")
end

Then /^I should see a record with the following detail:$/ do |detail|
  on_page_with :list do |page_model|
    page_model.records_attrs.sort.should == detail.hashes
  end
end

