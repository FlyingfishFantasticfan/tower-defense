extends CharacterBody2D

var is_selected : bool = false
var target_position :Vector2 = position
@export var SPEED : float = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if is_selected:
		velocity = position.direction_to(target_position) * SPEED
	else:
		velocity = Vector2(0,0)
		
	
	if position.distance_to(target_position) > 10:
		move_and_slide()
	else:
		position = target_position
