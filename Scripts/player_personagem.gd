extends CharacterBody2D

var _state_machine
var is_attacking: bool = false
var mov_lock: bool = true
@export_category("Variables")
@export var speed: float = 0
@export var friction: float = 0.2
@export var aceceleration: float = 0.2

@export_category("Objects")
@export var attack_timer: Timer = null
@export var animation_tree: AnimationTree = null

func _ready() -> void:
	_state_machine = animation_tree["parameters/playback"]

func _physics_process(_delta: float) -> void:
	move()
	attack()
	animate()
	move_and_slide()
	
func move() -> void:
	var direction_vector: Vector2 = Vector2(0, 0)

	if Input.is_action_pressed("move_right"):
		direction_vector.x += 1
	if Input.is_action_pressed("move_left"):
		direction_vector.x -= 1
	if Input.is_action_pressed("move_down"):
		direction_vector.y += 1
	if Input.is_action_pressed("move_up"):
		direction_vector.y -= 1

	if direction_vector != Vector2.ZERO:
		animation_tree["parameters/run/blend_position"] = direction_vector
		animation_tree["parameters/idle/blend_position"] = direction_vector
		animation_tree["parameters/attack/blend_position"] = direction_vector

		velocity = direction_vector.normalized() * speed
	else:
		velocity = Vector2.ZERO

func attack() -> void:
	if Input.is_action_just_pressed("attack") and not is_attacking:
		set_physics_process(false)
		attack_timer.start()
		is_attacking = true
	
func animate() ->void: 
	if is_attacking:
		_state_machine.travel("attack") 
		return
		
	if velocity.length() > 10:
		_state_machine.travel("run")
		return
	_state_machine.travel("idle")
	
		


func _on_attack_timer_timeout():
	set_physics_process(true)
	is_attacking = false
