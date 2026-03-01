extends CharacterBody2D
@onready var area = $Area2D
@onready var text = $RichTextLabel
const SPEED = 300.0
var JUMP_VELOCITY = -600
var onrope = false
var stop = false
func _ready() -> void:
	stop = true
	await get_tree().create_timer(1.3).timeout
	autoload.tutorial = 1
	stop = false
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() && not onrope:
		velocity += get_gravity() * delta

	# Handle jump.
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() || onrope) and stop == false:
		if onrope: _exit_rope()
		velocity.y = JUMP_VELOCITY
		if autoload.tutorial <= 1:
			autoload.tutorial = 2
	elif stop == true:
		pass
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("backward", "forward")
	var climbdirection := Input.get_axis('jump', "down")
	
	if onrope:
		if climbdirection: position.y += climbdirection
	else:	
		if direction && not onrope and stop == false:
			velocity.x = direction * SPEED
		elif not direction && not onrope or stop == true:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
func enter_rope(rope_area):
	onrope = true
	reparent(rope_area)
	#global_position = rope_area.get_rope_position(self)
	rotation_degrees = 0
	velocity = Vector2(0,0)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group('rope') && not onrope:
		call_deferred('enter_rope', area)

func _exit_rope():
	area.monitoring = false
	reparent(get_tree().current_scene)
	rotation_degrees = 0
	
	await get_tree().create_timer(0.4).timeout
	
	area.monitoring = true
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group('rope') && onrope:
		onrope = false
