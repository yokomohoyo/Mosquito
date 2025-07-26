extends CharacterBody2D

const SPEED := 250.0
const JUMP_VELOCITY := -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$JumpSfx.play()

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = (direction == -1)
	else:
		$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0.0, SPEED / 2.0)

	if not is_on_floor():
		$AnimatedSprite2D.play("jump")

	move_and_slide()

func die() -> void:
	# Stop processing so nothing else runs while we reset.
	set_physics_process(false)
	set_process(false)

	# Clear run-specific globals if needed.
	Global.gems_collected = 0

	# Defer the reload to the next moment in time.
	await get_tree().create_timer(0.05).timeout
	get_tree().reload_current_scene()
