Feature: Plugin install command
  In order to use this plugin
  As a user of Busser
  I want to run the postinstall for this plugin

  Background:
    Given a test BUSSER_ROOT directory named "busser-shunit2-install"

  Scenario: Running the postinstall generator
    When I run `busser plugin install busser-shunit2 --force-postinstall`
    Then the vendor directory named "shunit2" should exist
    And the vendor file "shunit2/shunit2" should contain "SHUNIT_VERSION="
    And the vendor file "shunit2/runner" should contain "#!/bin/bash"
    And the exit status should be 0
