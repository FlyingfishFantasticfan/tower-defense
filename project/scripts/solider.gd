extends CharacterBody2D

enum Direction{
	up,
	buttom,
	right,
	left
}


var direction : Direction = Direction.buttom
var is_selected : bool = false
var target_position :Vector2
var is_moving :bool = false
var is_working :bool = false


@onready var highlighted_boxes: Sprite2D = $"Highlighted-boxes"
@onready var animation: AnimatedSprite2D = $animation
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


@export var SPEED : float = 200
@export var HP :int = 100
@export var HTK: int = 5  #同时是攻击力、建造速度、采集速度

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	target_position = position
	highlighted_boxes.visible = false
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	
	if position.distance_to(target_position) > 20:
		velocity = position.direction_to(target_position) * SPEED
		move_and_slide()
	else:
		velocity = Vector2(0 ,0)
	
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
		target_position = target

func _set_selected(area) -> void:
	var rect = highlighted_boxes.get_rect()
	rect.position = to_global(rect.position)
	if rect.intersects(area):
		is_selected = not  is_selected
