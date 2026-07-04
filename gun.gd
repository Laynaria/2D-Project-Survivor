extends Area2D

func _physics_process(_delta: float) -> void:
	var ennemies_in_range = get_overlapping_bodies()
	if ennemies_in_range.size() > 0:
		var guns = get_tree().get_nodes_in_group("Gun")
		var current_gun = get_child(0).get_parent()
		var gun_number = guns.find(current_gun)
		var target_check = gun_number if ennemies_in_range.size() >= guns.size() else 0
		var target_ennemy = ennemies_in_range[target_check]
		look_at(target_ennemy.global_position)

func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)

func _on_timer_timeout() -> void:
	shoot()
