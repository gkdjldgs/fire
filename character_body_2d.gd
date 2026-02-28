extends CharacterBody2D
@onready var area = $Area2D/CollisionShape2D

const SPEED = 300.0
var JUMP_VELOCITY = -700
var onrope = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() && not onrope:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() || onrope):
		if onrope: _exit_rope()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("backward", "forward")
	var climbdirection := Input.get_axis('jump', "down")
	
	if onrope:
		if climbdirection: position.y += climbdirection
	else:	
		if direction && not onrope:
			velocity.x = direction * SPEED
		elif not direction && not onrope:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
func enter_rope(area):
	onrope = true
	reparent(area)
	global_position = area.get_rope_position(self)
	rotation_degrees = 0
	velocity = Vector2(0,0)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group('rope') && not onrope:
		call_deferred('enter_rope', area)

func _exit_rope():
	area.monitoring = false
	reparent(get_tree().current_scene)
	rotation_degrees = 0
	
	await get_tree().create_timer(0.2).timeout
	
	area.monitoring = true
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group('rope') && onrope:
		onrope = false
