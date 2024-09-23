extends Area2D

signal attract
signal effect

var Type:String

@onready var attract_zone: Area2D = $"."

@export var 优先度:int
var is_full := false

func _on_body_entered(body: Node2D) -> void:
	attract.connect(body._set_new_attract_target)
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body.attract_target == attract_zone:
		body.attract_target = null
		is_full = false
	attract.disconnect(body._set_new_attract_target)
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	if not is_full:
		emit_signal("attract",attract_zone)
	pass # Replace with function body.

func _do_effect(value:int) ->void:
	emit_signal("effect",value)
