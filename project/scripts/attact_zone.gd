extends Area2D

signal attract
@onready var attract_zone: Area2D = $"."

@export var 优先度:int
var is_full := false




func _on_body_entered(body: Node2D) -> void:
	print("attract")
	attract.connect(body._set_new_attract_target)
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	attract.disconnect(body._set_new_attract_target)
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	emit_signal("attract",attract_zone)
	pass # Replace with function body.
