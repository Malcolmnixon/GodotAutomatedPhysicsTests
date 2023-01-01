extends Node


signal failure(description)


## Flag to animate physics
var animate : bool = false


## Report failure
func fail(reason : String) -> void:
	failure.emit(reason)


## Assert value is null
func is_null(value, message : String) -> void:
	if value:
		failure.emit(message)


## Assert value is not null
func is_not_null(value, message : String) -> void:
	if not value:
		failure.emit(message)


## Assert integers are equal
func are_equal_int(
		expected : int,
		actual : int,
		message : String) -> void:
	if actual != expected:
		failure.emit("{act} != {exp} : {msg}".format({ 
				"act": actual, 
				"exp": expected, 
				"msg": message}))


## Assert integers are not equal
func are_not_equal_int(
		expected : int,
		actual : int,
		message : String) -> void:
	if actual == expected:
		failure.emit("{act} == {exp} : {msg}".format({
				"act": actual,
				"exp": expected,
				"msg": message}))


## Assert vectors are equal within tolerance
func are_equal_vec3(
		expected : Vector3,
		actual : Vector3,
		message : String,
		tolerance : float) -> void:
	if expected.distance_to(actual) > tolerance:
		failure.emit("{act} != {exp} : {msg}".format({
				"act": actual,
				"exp": expected,
				"msg": message}))


## Assert vectors are not equal within tolerance
func are_not_equal_vec3(
		expected : Vector3,
		actual : Vector3,
		message : String,
		tolerance : float) -> void:
	if expected.distance_to(actual) <= tolerance:
		failure.emit("{act} == {exp} : {msg}".format({
				"act": actual,
				"exp": expected,
				"msg": message}))

