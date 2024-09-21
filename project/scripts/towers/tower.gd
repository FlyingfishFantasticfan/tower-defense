extends Node2D

@export var collision_shape_2d: CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@export_file($Area2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("Area2D").add_child(collision_shape_2d)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	print("enter")
	pass # Replace with function body.
