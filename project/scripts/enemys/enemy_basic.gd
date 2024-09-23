extends CharacterBody2D

@export var HP : int = 1000
@export var SPEED:float = 100
@export var ATK:int = 5
@export var TYPE:="Enemy"

@onready var attract_zones: Node2D = $attract_zones
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animation: AnimatedSprite2D = $animation

var is_attack = false
var target:Node2D
var move_target:Node2D
var attack_target:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigation_agent_2d.max_speed = SPEED
	for i in attract_zones.get_child_count():
		attract_zones.get_child(i).Type = "Enemy"
		attract_zones.get_child(i).effect.connect(add_hp)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_attack:
		navigation_agent_2d.target_position = attack_target.global_position
	elif move_target != null:
		print("2")
		navigation_agent_2d.target_position = move_target.global_position
	
	if not navigation_agent_2d.is_navigation_finished():
		var direction = to_local(navigation_agent_2d.get_next_path_position()).normalized()
		navigation_agent_2d.set_velocity(direction*SPEED)

	
	if is_attack:	
		animation.play("attack")
	else:
		animation.play("move")

func add_hp(value:int)->void:
	HP += value
	if HP <= 0:
		queue_free()

func get_type()->String:
	return TYPE


func _on_vision_zone_body_entered(body: Node2D) -> void:
	if move_target == null:
		move_target = body
		print("set target")
	if global_position.distance_to(move_target.global_position) > global_position.distance_to(body.global_position):
		move_target = body

func _on_vision_zone_body_exited(body: Node2D) -> void:
	
	pass # Replace with function body.


func _on_attack_zone_body_entered(body: Node2D) -> void:
	if attack_target == null:
		is_attack = true
		attack_target = body
	pass # Replace with function body.


func _on_attack_zone_body_exited(body: Node2D) -> void:
	if body == attack_target:
		is_attack =false
		attack_target =null
	pass # Replace with function body.


func _on_animation_animation_finished() -> void:
	if attack_target != null:
		attack_target._add_hp(-ATK)
	pass # Replace with function body.


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
	pass # Replace with function body.
