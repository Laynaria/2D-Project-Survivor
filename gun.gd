extends Area2D

@onready var agi: float = float(get_node("/root/Game/Player").agi) # importing agi variable

func _physics_process(delta: float) -> void:
	var ennemies_in_range = get_overlapping_bodies()
	if ennemies_in_range.size() > 0:
		var guns = get_tree().get_nodes_in_group("Gun")
		var current_gun = get_child(0).get_parent()
		var gun_number = guns.find(current_gun)
		
		# new logic of sorting array to improve targeting of monsters
		var player: CharacterBody2D = current_gun.get_parent()
		# can lag if too many guns
		ennemies_in_range.sort_custom(func(a, b): return player.position.distance_to(a.position) < player.position.distance_to(b.position))
		# end of new logic
		
		var target_check = gun_number if ennemies_in_range.size() >= guns.size() else 0
		var target_ennemy = ennemies_in_range[target_check]
		# look_at(target_ennemy.global_position)
		
		# smoother rotation of gun
		var ennemyPos = target_ennemy.global_position
		ennemyPos = global_position.angle_to_point(ennemyPos)
		ennemyPos = lerp_angle(rotation, ennemyPos, delta * 10)
		ennemyPos = wrapf(ennemyPos, -PI, PI)
		rotation = ennemyPos
		
		
	%Timer.wait_time = (0.3 - (agi / 660))

func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)

func _on_timer_timeout() -> void:
	shoot()
