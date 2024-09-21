extends Node2D

var mouse_pos:Vector2
@onready var select_panel: Panel = $SelectPanel

var is_pressed := false
var start_pos:Vector2
var end_pos:Vector2
var area:Rect2

signal left_mouse_click
signal right_mouse_click
signal select

@onready var soilders: Node = $soilders

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	for i in range(soilders.get_child_count()):
		select.connect(soilders.get_child(i)._set_selected)
		right_mouse_click.connect(soilders.get_child(i)._set_new_target)
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		if is_pressed:
			end_pos = get_global_mouse_position()
			var panel_pos = Vector2(min(start_pos.x,end_pos.x),min(start_pos.y,end_pos.y))
			var panel_size = abs(start_pos - end_pos)
			area = Rect2(panel_pos, panel_size)
			select_panel.position = panel_pos
			select_panel.size = panel_size
			
	if event is InputEventMouseButton and event.button_index ==1 and event.pressed == true:
		is_pressed = true
		start_pos = get_global_mouse_position()
	if event is InputEventMouseButton and event.button_index ==1 and event.pressed == false:
		is_pressed = false
		end_pos = get_global_mouse_position()
		if start_pos.distance_to(end_pos) < 3:
			emit_signal("left_mouse_click")
		else :
			emit_signal("select",area)
		select_panel.size = Vector2(0,0)
	
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		emit_signal("right_mouse_click" , get_global_mouse_position())	
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
