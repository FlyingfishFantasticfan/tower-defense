extends CharacterBody2D

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


@onready var highlighted_boxes: Sprite2D = $"Highlighted-boxes"
@onready var animation: AnimatedSprite2D = $Animation
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D


@export var SPEED : float = 100
@export var HP :int = 100
@export var HTK: int = 5  #同时是攻击力、建造速度、采集速度

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigation_agent_2d.max_speed = SPEED
	highlighted_boxes.visible = false
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if not navigation_agent_2d.is_navigation_finished():
		var direction = to_local(navigation_agent_2d.get_next_path_position()).normalized()
		navigation_agent_2d.set_velocity(direction*SPEED)

	
#更新移动状态
	if velocity == Vector2(0,0):
		is_moving = false
	else:
		is_moving = true
		#更新朝向
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
	
	update_anim()




func update_anim() -> void :
	if is_selected:
		highlighted_boxes.visible = true
	else:
		highlighted_boxes.visible = false


	match direction:
		Direction.left:
			if is_moving:
				animation.play("run_left")
			elif is_working:
				animation.play("work_left")
			else :
				animation.play("idle_left")
		Direction.right:
			if is_moving:
				animation.play("run_right")
			elif is_working:
				animation.play("work_right")
			else :
				animation.play("idle_right")
		Direction.buttom:
			if is_moving:
				animation.play("run_buttom")
			elif is_working:
				animation.play("work_buttom")
			else :
				animation.play("idle_buttom")
		Direction.up:
			if is_moving:
				animation.play("run_up")
			elif is_working:
				animation.play("work_up")
			else :
				animation.play("idle_up")



func _set_new_target(target) ->void:
	if is_selected:
		is_selected = false
		navigation_agent_2d.target_position = target

func _set_selected(area) -> void:
	var rect = highlighted_boxes.get_rect()
	rect.position = to_global(rect.position)
	if rect.intersects(area):
		is_selected = not is_selected


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
	pass # Replace with function body.


func _on_navigation_agent_2d_navigation_finished() -> void:
	velocity = Vector2(0,0)
	print("over")
	pass # Replace with function body.
