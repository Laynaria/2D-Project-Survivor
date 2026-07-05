extends Node2D

@onready var previous_position = $Player.position
const MAX_TREE = 50
var tree_count = 0
var walk_distance = 0

var max_mobs = 50
var mob_count = 0
var killed_count = 0

var lvl = 1
var xp = 0

func _ready() -> void:
	$Music.play()
	%GameOver.hide()
	for n in range(10) :
		spawn_tree()

func _physics_process(_delta: float) -> void:
	if $Player.position != previous_position :
		walk_distance += 1
		previous_position = $Player.position
	
	if walk_distance == 10:
		spawn_tree()
		tree_count += 1
		walk_distance = 0
		
		var trees = get_tree().get_nodes_in_group("Tree")
		var previous_tree = trees[0] if trees.size() > 1 else null
		
		for tree in range(trees.size()):
			var current_tree = trees[tree]
			if $Player.position.distance_to(previous_tree.position) < $Player.position.distance_to(current_tree.position):
				previous_tree = current_tree
		if trees and tree_count > MAX_TREE:
			previous_tree.queue_free()
			tree_count -= 1

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
	killed_count += 1
	xp += 5
	var slime_or_slimes = "slime" if killed_count <= 1 else "slimes"
	%KilledLabel.text = "%s %s killed" % [killed_count, slime_or_slimes]
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
	%DeathSound.play()
	get_tree().paused = true

func restart():
	get_tree().paused = false
	%GameOver.hide()
	get_tree().reload_current_scene()
	
func spawn_tree():
	var new_tree = preload("res://pine_tree.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_tree.global_position =  %PathFollow2D.global_position
	add_child(new_tree)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and get_tree().paused == false:
		get_tree().paused = true
		%Pause.show()

func unpause():
	get_tree().paused = false
	%Pause.hide()

func _on_unpause_pressed() -> void:
	unpause()
