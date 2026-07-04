extends Node2D

var max_mobs = 50
var mob_count = 0

var lvl = 1
var xp = 0

func _ready() -> void:
	%GameOver.hide()

func spawn_mob():
	if mob_count >= max_mobs:
		return
	
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position =  %PathFollow2D.global_position
	add_child(new_mob)
	
	mob_count += 1
	new_mob.tree_exited.connect(_on_mob_tree_exited)

func _on_mob_tree_exited():
	mob_count -= 1
	xp += 5
	if xp >= 100 and lvl < 99:
		xp = 0
		lvl += 1
		%LvlLabel.text = "Lv. %s" % lvl
		$Player.level_up()
		$MobSpawnTimer.wait_time *= 0.8
		max_mobs += 1
	%ExpBar.value = xp

func _on_mob_spawn_timer_timeout() -> void:
	spawn_mob()

func _on_start_pressed() -> void:
	restart()

func _on_player_health_depleted() -> void:
	%GameOver.show()
	$HUD/DeathSound.play()
	get_tree().paused = true

func restart():
	get_tree().paused = false
	%GameOver.hide()
	get_tree().reload_current_scene()
	
