extends Node2D

@onready var stat_point_label = get_node("/root/Game/LevelUp/StatPoints")
@onready var hud_atk_label = get_node("/root/Game/HUD/AtkLabel")
@onready var hud_agi_label = get_node("/root/Game/HUD/AgiLabel")
@onready var hud_vit_label = get_node("/root/Game/HUD/VitLabel")

@onready var player = get_node("/root/Game/Player")
@onready var current_atk = player.atk
@onready var current_agi = player.agi
@onready var current_vit = player.vit

var current_point = 1

func _ready() -> void:
	update_stat_point_label()
	update_atk_label()
	update_agi_label()
	update_vit_label()
	
func update_stat_point_label() ->void:
	stat_point_label.text = "Allocate your points: %s" % current_point

func update_atk_label() -> void:
	%AtkLabel.text = "%s Atk" % current_atk

func update_agi_label() -> void:
	%AgiLabel.text = "%s Agi" % current_agi

func update_vit_label() -> void:
	%VitLabel.text = "%s Vit" % current_vit

func _on_atk_plus_pressed() -> void:
	if current_point > 0:
		current_atk += 1
		current_point -= 1
		update_atk_label()
		update_stat_point_label()

func _on_atk_minus_pressed() -> void:
	if current_atk > player.atk:
		current_atk -= 1
		current_point += 1
		update_atk_label()
		update_stat_point_label()

func _on_agi_plus_pressed() -> void:
	if current_point > 0:
		current_agi += 1
		current_point -= 1
		update_agi_label()
		update_stat_point_label()

func _on_agi_minus_pressed() -> void:
	if current_agi > player.agi:
		current_agi -= 1
		current_point += 1
		update_agi_label()
		update_stat_point_label()

func _on_vit_plus_pressed() -> void:
	if current_point > 0:
		current_vit += 1
		current_point -= 1
		update_vit_label()
		update_stat_point_label()

func _on_vit_minus_pressed() -> void:
	if current_vit > player.vit:
		current_vit -= 1
		current_point += 1
		update_vit_label()
		update_stat_point_label()

func _on_validate_points_pressed() -> void:
	if current_atk > player.atk:
		player.add_atk()
		hud_atk_label.text = "%s Atk" % current_atk
	if current_agi > player.agi:
		player.add_agi()
		hud_agi_label.text = "%s Agi" % current_agi
	if current_vit > player.vit:
		player.add_vit()
		hud_vit_label.text = "%s Vit" % current_vit
	if current_point == 0:
		current_point += 1
		update_stat_point_label()
		get_tree().paused = false
		get_node("/root/Game/LevelUp").hide()
