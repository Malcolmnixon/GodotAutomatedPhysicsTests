extends Node3D


## Tolerance for collision positions
const POSITION_TOLERANCE := 0.01

## Tolerance for collision normals
const NORMAL_TOLERANCE := 0.001


func test_scan_x_pos():
	for y in 11:
		for z in 11:
			$Character.global_position = Vector3(103, y-5, z-5)
			var collide : KinematicCollision3D = $Character.move_and_collide(Vector3(-10, 0, 0))

			# Short delay
			if Test.animate:
				await get_tree().create_timer(0.01).timeout

			# Ensure collision
			Test.is_not_null(collide, "Collision not detected")
			if !collide:
				continue

			# Ensure normal
			Test.are_equal_vec3(
				Vector3(1, 0, 0),
				collide.get_normal(),
				"Collision normal",
				NORMAL_TOLERANCE)

func test_scan_x_neg():
	for y in 11:
		for z in 11:
			$Character.global_position = Vector3(-103, y-5, z-5)
			var collide : KinematicCollision3D = $Character.move_and_collide(Vector3(10, 0, 0))

			# Short delay
			if Test.animate:
				await get_tree().create_timer(0.01).timeout

			# Ensure collision
			Test.is_not_null(collide, "Collision not detected")
			if !collide:
				continue

			# Ensure normal
			Test.are_equal_vec3(
				Vector3(-1, 0, 0),
				collide.get_normal(),
				"Collision normal",
				NORMAL_TOLERANCE)

func test_scan_y_pos():
	for x in 11:
		for z in 11:
			$Character.global_position = Vector3(x-5, 53, z-5)
			var collide : KinematicCollision3D = $Character.move_and_collide(Vector3(0, -10, 0))

			# Short delay
			if Test.animate:
				await get_tree().create_timer(0.01).timeout

			# Ensure collision
			Test.is_not_null(collide, "Collision not detected")
			if !collide:
				continue

			# Ensure normal
			Test.are_equal_vec3(
				(collide.get_position() * Vector3(0, 1, 1)).normalized(),
				collide.get_normal(),
				"Collision normal",
				NORMAL_TOLERANCE)

func test_scan_y_neg():
	for x in 11:
		for z in 11:
			$Character.global_position = Vector3(x-5, -53, z-5)
			var collide : KinematicCollision3D = $Character.move_and_collide(Vector3(0, 10, 0))

			# Short delay
			if Test.animate:
				await get_tree().create_timer(0.01).timeout

			# Ensure collision
			Test.is_not_null(collide, "Collision not detected")
			if !collide:
				continue

			# Ensure normal
			Test.are_equal_vec3(
				(collide.get_position() * Vector3(0, 1, 1)).normalized(),
				collide.get_normal(),
				"Collision normal",
				NORMAL_TOLERANCE)

func test_scan_z_pos():
	for x in 11:
		for y in 11:
			$Character.global_position = Vector3(x-5, y-5, 53)
			var collide : KinematicCollision3D = $Character.move_and_collide(Vector3(0, 0, -10))

			# Short delay
			if Test.animate:
				await get_tree().create_timer(0.01).timeout

			# Ensure collision
			Test.is_not_null(collide, "Collision not detected")
			if !collide:
				continue

			# Ensure normal
			Test.are_equal_vec3(
				(collide.get_position() * Vector3(0, 1, 1)).normalized(),
				collide.get_normal(),
				"Collision normal",
				NORMAL_TOLERANCE)

func test_scan_z_neg():
	for x in 11:
		for y in 11:
			$Character.global_position = Vector3(x-5, y-5, -53)
			var collide : KinematicCollision3D = $Character.move_and_collide(Vector3(0, 0, 10))

			# Short delay
			if Test.animate:
				await get_tree().create_timer(0.01).timeout

			# Ensure collision
			Test.is_not_null(collide, "Collision not detected")
			if !collide:
				continue

			# Ensure normal
			Test.are_equal_vec3(
				(collide.get_position() * Vector3(0, 1, 1)).normalized(),
				collide.get_normal(),
				"Collision normal",
				NORMAL_TOLERANCE)

func test_scan_x_pos_ring():
	for x in 100:
		var theta : float = x * TAU / 100
		var s = sin(theta)
		var c = cos(theta)
		$Character.global_position = Vector3(103, s * 53, c * 53)
		var collide : KinematicCollision3D = $Character.move_and_collide(Vector3(-10, -s*10, -c*10))

		# Short delay
		if Test.animate:
			await get_tree().create_timer(0.01).timeout
		
		# Ensure collision
		Test.is_not_null(collide, "Collision not detected")
		if !collide:
			continue

		# Ensure normal
		Test.are_equal_vec3(
			Vector3(1, s, c).normalized(),
			collide.get_normal(),
			"Collision normal",
			NORMAL_TOLERANCE)
