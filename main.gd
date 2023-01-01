extends Node3D


var _current_test_scene : String

var _current_test_method : String

var _current_method_errors : int

var _total_count : int = 0

var _failed_count : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# Check for animation arguments
	if DisplayServer.get_name() != "headless":
		Test.animate = true

	# Run all tests
	await _run_all_test_suites()

	# Print summary
	if _failed_count == 0:
		print("Passed all {total} tests".format(
			{"total": _total_count}))
	else:
		print("Failed {failed} of {total} tests".format(
			{"failed": _failed_count, "total": _total_count}))

	# Quit the application
	await get_tree().create_timer(1).timeout
	get_tree().quit(1)


# Run all test suites
func _run_all_test_suites() -> void:
	# Listen for assert failures
	Test.connect("failure", _on_test_failure)

	# Iterate over all test suite scenes
	for scene in _find_all_tests():
		await _run_test_suite(scene)

	# Disconnect assert failures
	Test.disconnect("failure", _on_test_failure)


func _run_test_suite(scene_name : String):
	# Load the scene
	_current_test_scene = scene_name
	var scene_prefab : PackedScene = load(scene_name)
	var scene_inst := scene_prefab.instantiate()
	add_child(scene_inst)
	
	# Delay to let scene start
	await get_tree().create_timer(0.1).timeout

	# Run any test suite initialization
	if scene_inst.has_method("on_suite_initialize"):
		await scene_inst.on_suite_initialize()

	# Run all the test methods
	for method in _find_test_methods(scene_inst):
		await _run_test_method(scene_inst, method)

	# Run any test suite cleanup
	if scene_inst.has_method("on_suite_cleanup"):
		await scene_inst.on_suite_cleanup()

	# Free the scene
	remove_child(scene_inst)
	scene_inst.queue_free()
	

# Run a test method in the suite
func _run_test_method(inst : Node, method : String) -> void:
	# Log the start of the test method
	_current_test_method = method
	_current_method_errors = 0
	_total_count += 1

	# Perform test initialization
	if inst.has_method("on_test_initialize"):
		await inst.on_test_initialize()

	# Run the test method
	await inst.call(method)

	# Perform test cleanup
	if inst.has_method("on_test_cleanup"):
		await inst.on_test_cleanup()

	if _current_method_errors == 0:
		print("{suite}::{test}: pass".format({
				"suite": _current_test_scene,
				"test": method}))
	else:
		_failed_count += 1


# Handle test failure
func _on_test_failure(description : String) -> void:
	_current_method_errors += 1
	print("{suite}::{test} : {msg}".format({
			"suite": _current_test_scene,
			"test": _current_test_method,
			"msg": description}))


# Find all test scenes
static func _find_all_tests() -> Array[String]:
	var tests : Array[String] = []
	_find_tests_in_folder("res://", tests)
	return tests


# Find tests in a directory
static func _find_tests_in_folder(dir: String, tests: Array[String]):
	# Add all test scenes
	for file in DirAccess.get_files_at(dir):
		if file.begins_with("test_") and file.ends_with(".tscn"):
			tests.append(dir + "/" + file)

	# Search sub-directories
	for sub in DirAccess.get_directories_at(dir):
		_find_tests_in_folder(dir + "/" + sub, tests)


# Find test methods in object
static func _find_test_methods(inst : Node) -> Array[String]:
	# Iterate over all methods
	var test_methods : Array[String] = []
	for method in inst.get_method_list():
		# Add the test methods
		var method_name : String = method["name"]
		if method_name.begins_with("test_"):
			test_methods.append(method_name)

	return test_methods
