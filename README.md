# Godot Automated Physics Tests
This project contains a set of automated physics tests for godot.

# Executing Tests
The tests can be executed from Godot, and will render a preview of the tests
in 3D; however the test execution is slowed to allow developers to observe
the tests.

Use the "--headless" command-line argument to run at full speed:
```   godot.exe --path=. --headless```

# Adding New Tests
The project finds tests scenes anywhere in the project with a name of ```test_*.tscn```.
After instantiating the scene, the project will execute any ```test_*()``` method in the scene class file.
