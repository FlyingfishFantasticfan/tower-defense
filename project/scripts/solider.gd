extends CharacterBody2D
class_name  Solider

enum Direction{
	up,
	buttom,
	right,
	left
}


var direction : Direction = Direction.buttom
var is_selected : bool = false
var is_moving :bool = false
var is_working :bool = false
var is_attack :bool = false

var attract_target:Node2D 

@onready var highlighted_boxes: Sprite2D = $"Highlighted-boxes"
@onready var animation: AnimatedSprite2D = $Animation
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer


@export var SPEED : float = 100
@export var HP :int = 100
@export var ATK: int = 5
@export var RADIUS :int =12
@export var WORK_SPEED :int =5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigation_agent_2d.max_speed = SPEED
	highlighted_boxes.visible = false
	pass # Replace with function body.

func _physics_process(delta: float) -> void:

	if not navigation_agent_2d.is_navigation_finished():
		var direction = to_local(navigation_agent_2d.get_next_path_position()).normalized()
		navigation_agent_2d.set_velocity(direction*SPEED)
	
	




func update_anim() -> void :
	if is_selected:
		highlighted_boxes.visible = true
	else:
		highlighted_boxes.visible = false


	match direction:
		Direction.left:
			if is_moving:

				animation.play("run_left")
			elif is_attack :
				animation.play("attack_left")
			elif is_working:
				animation.play("work_left")
			else :
				animation.play("idle_left")
		Direction.right:
			
			if is_moving:

				
				animation.play("run_right")
			elif is_attack :
				animation.play("attack_right")
			elif is_working:
				animation.play("work_right")
			else :
				animation.play("idle_right")
		Direction.buttom:
			if is_moving:

				
				animation.play("run_buttom")
			elif is_attack :
				animation.play("attack_buttom")
			elif is_working:
				animation.play("work_buttom")
			else :
				animation.play("idle_buttom")
		Direction.up:	
			if is_moving:
				
				animation.play("run_up")
			elif is_attack:
				animation.play("attack_up")
			elif is_working:
				animation.play("work_up")
			else :
				animation.play("idle_up")



func _set_new_target(target) ->void:
	if is_selected:
		navigation_agent_2d.target_desired_distance = 15
		if attract_target!=null && is_attack||is_working:
			attract_target.is_full = false
			attract_target = null
		is_moving = true
		is_attack = false
		is_working = false
		is_selected = false
		navigation_agent_2d.target_position = target

func _set_selected(area) -> void:
	var rect = highlighted_boxes.get_rect()
	rect.position = to_global(rect.position)
	if rect.intersects(area):
		is_selected = not is_selected

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	var abs_v = velocity.abs()
	if abs_v.x > abs_v.y:
		if velocity.x < 0:
			direction = Direction.left
		elif velocity.x > 0:
			direction = Direction.right
	elif abs_v.x < abs_v.y:
		if velocity.y < 0:
			direction = Direction.up
		elif velocity.y > 0:
			direction = Direction.buttom
	move_and_slide()
	
	pass # Replace with function body.

func _on_navigation_agent_2d_navigation_finished() -> void:
	is_moving = false
	pass # Replace with function body.

	
func _set_new_attract_target(_attract_target)-> void:
	if is_working||is_attack:
		return

	if attract_target == null:
		attract_target = _attract_target

	if  _attract_target.优先度 > attract_target.优先度:
		attract_target = _attract_target
	elif _attract_target.优先度 == attract_target.优先度:
		if global_position.distance_to(_attract_target.global_position) < global_position.distance_to(attract_target.global_position):
			attract_target = _attract_target



func _on_timer_timeout() -> void:
	update_anim()
	if attract_target == null || is_moving:
		is_attack = false
		is_working = false
		return
	if attract_target.is_full == true && not is_attack && not is_working:
		navigation_agent_2d.target_position = global_position
		attract_target = null
		return
	
	if global_position.distance_to(attract_target.global_position) >= RADIUS*3:
		navigation_agent_2d.target_desired_distance = 12
		navigation_agent_2d.target_position = attract_target.global_position
	else:
		if global_position.distance_to(attract_target.global_position) >= RADIUS:
			navigation_agent_2d.target_desired_distance = 12
			navigation_agent_2d.target_position = attract_target.global_position

		if attract_target.Type == "Enemy":
			is_attack = true
		else :
			is_working = true
		attract_target.is_full = true

func _on_animation_animation_finished() -> void:
	if	attract_target!=null && attract_target.Type == "Enemy":
		attract_target._do_effect(-ATK)
		print("攻击")

func _add_hp(value :int)->void:
	
	HP += value

	if HP <= 0:
		queue_free()
