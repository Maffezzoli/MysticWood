extends CharacterBody2D
class_name slime
var is_dead: bool = false
var player_ref = null
@export var speed: int
@export_category("Objects")
@export var texture: Sprite2D = null
@export var animation: AnimationPlayer = null


func _on_detection_area_body_entered(body):
	if body.is_in_group("character"):
		player_ref = body


func _on_detection_area_body_exited(body):
	if body.is_in_group("character"):
		player_ref = null
func _physics_process(delta: float) -> void:
	if is_dead:
		return
	animate()
	if player_ref != null:
		if  player_ref.is_dead:
			velocity = Vector2.ZERO
			move_and_slide()
			return
		var direction: Vector2 = global_position.direction_to(player_ref.global_position)
		var distance: float = global_position.distance_to(player_ref.global_position)
		
		if distance < 0:
			player_ref.die()
		
		velocity = direction * speed
		move_and_slide()

func animate() -> void:
	if velocity.x > 0:
		texture.flip_h = false
	if velocity.x < 0:
		texture.flip_h = true
	
	if velocity != Vector2.ZERO:
		animation.play("walk")
		return
	animation.play("idle")
func update_health() -> void:
	is_dead = true
	animation.play("dead")
func _on_animation_player_animation_finished(anim_name):
	queue_free()
