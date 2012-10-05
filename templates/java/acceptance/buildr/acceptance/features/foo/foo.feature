Feature:
  As a user
  I want to get to the home page

  Scenario: User on the home page
    When I am on the home page
    Then I should see hello to "foo" on home page

  Scenario: create foo
    When I am on the creation page
    And I create a record with the following detail:
      | name | data      |
      | test | test-data |
    When I am on the list page
    Then I should see a record with the following detail:
      | name | data      |
      | test | test-data |
