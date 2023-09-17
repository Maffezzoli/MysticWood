extends Area2D
class_name door_component

var player_ref: character = null

@export_category("Variables")
@export var teleport_position: Vector2
@export_category("Objects")
@export var animation: AnimationPlayer = null

func _on_body_entered(body) -> void:
	if body is character:
		player_ref = body
		animation.play("open")


func _on_animation_animation_finished(anim_name: String) -> void:
	if anim_name == "open":
		player_ref.global_position = teleport_position
		animation.play("close")
