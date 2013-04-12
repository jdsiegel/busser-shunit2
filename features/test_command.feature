Feature: Test command
  In order to run tests written with shunit2
  As a user of Busser
  I want my tests to run when the shunit2 runner plugin is installed

  Background:
    Given a test BUSSER_ROOT directory named "busser-shunit2-test"
    When I successfully run `busser plugin install busser-shunit2 --force-postinstall`
    Given a suite directory named "shunit2"

  Scenario: A passing test suite
    Given a file in suite "shunit2" named "foo_spec.sh" with:
    """
    test_pass()
    {
      assertEquals "kitchen" "kitchen"
    }
    """
    When I run `busser test shunit2`
    Then the output should contain:
    """
    [shunit2] foo_spec.sh
    test_pass

    Ran 1 test.

    OK
    """
    And the exit status should be 0

  Scenario: A failing test suite
    Given a file in suite "shunit2" named "foo_spec.sh" with:
    """
    test_fail()
    {
      assertEquals "kitchen" "jamie"
    }
    """
    When I run `busser test shunit2`
    Then the output should contain:
    """
    test_fail
    ASSERT:expected:<kitchen> but was:<jamie>

    Ran 1 test.

    FAILED (failures=1)
    """
    And the exit status should not be 0
