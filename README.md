# Godot Automated Physics Tests

This project contains a set of automated physics tests for godot.


# Executing Tests

When executed as a normal project, the tests will be rendered in 3D and 
slowed to allow developers to observe the physical layout of thw tests.

When run headless using the "--headless" command-line argument, the tests
will run at full speed:

```godot.exe --path=. --headless```


# Adding New Tests

The project finds tests scenes anywhere in the project with a name of ```test_*.tscn```.
After instantiating the scene, the project will execute any ```test_*()``` method in the scene class file.
