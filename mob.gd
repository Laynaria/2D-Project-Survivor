extends CharacterBody2D

@onready var player = get_node("/root/Game/Player") # importing a scene to use variables from it
@onready var player_lvl = get_node("/root/Game").player_lvl # importing directly a variable from a scene

var health = 2
var speed = 300.0

func _ready():
	%Slime.play_walk()
	
	# difficulty of slime based on player lvl
	if player_lvl >= 10:
		# yellow slime
		%Slime/Anchor.modulate = Color(2.427, 2.496, 0.719, 0.873)
		health = 8
		speed = 350.0
		
	if player_lvl >= 20:
		# blue slime
		%Slime/Anchor.modulate = Color(0.0, 0.54, 3.705, 0.898)
		health = 16
		speed = 400.0
		
	if player_lvl >= 40:
		# red slime
		%Slime/Anchor.modulate = Color(1.0, 0.0, 1.0, 0.898)
		health = 32
		speed = 450.0
		
	if player_lvl >= 80:
		# purple slime
		%Slime/Anchor.modulate = Color(0.834, 0.0, 2.816)
		health = 64
		speed = 500.0
		
	if player_lvl >= 99 :
		health = 12800
		speed = 550.0
		$".".scale = Vector2(5, 5)
		$".".set_collision_mask_value(3, false)

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	velocity.normalized()
	move_and_slide()

func take_damage():
	health -= ceil(player.atk / 3.1) # a way to make dmg higher, need to be thought with leveling system
	%Slime.play_hurt()
	
	if health <= 0:
		queue_free()
		
		const SMOKE_SCENE = preload("res://assets/smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		smoke.global_position = %Slime.global_position
		get_parent().add_child(smoke)
