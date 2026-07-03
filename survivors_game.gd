extends Node2D

const MAX_MOBS = 50
var mob_count = 0

func _ready() -> void:
	%GameOver.hide()

func spawn_mob():
	if mob_count >= MAX_MOBS:
		return
	
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position =  %PathFollow2D.global_position
	add_child(new_mob)
	
	mob_count += 1
	new_mob.tree_exited.connect(_on_mob_tree_exited)

func _on_mob_tree_exited():
	mob_count -= 1

func _on_mob_spawn_timer_timeout() -> void:
	spawn_mob()

func _on_start_pressed() -> void:
	restart()

func _on_player_health_depleted() -> void:
	%GameOver.show()
	get_tree().paused = true

func restart():
	get_tree().paused = false
	%GameOver.hide()
	get_tree().reload_current_scene()
