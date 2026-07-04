extends CharacterBody2D

signal health_depleted

var health = 100.0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	velocity.normalized()
	move_and_slide()
	
	# We use % instead of dollar, after having made the HappyBoo scene to be unique, for performances
	# This way, it loads the node only once for calculations > it only works on the scene where you made it unique
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		if health <= 0.0:
			health_depleted.emit()

func level_up():
	var new_gun = preload("res://gun.tscn").instantiate()
	# %PathFollow2D.progress_ratio = randf()
	# new_gun.global_position =  %PathFollow2D.global_position
	add_child(new_gun)
