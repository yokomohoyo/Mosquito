extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$JumpSfx.play()

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run")
		if direction == -1:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)

	if not is_on_floor():
		$AnimatedSprite2D.play("jump")

	move_and_slide()


func die():
    # Called when the player collides with a deadly object (e.g.
    # mosquito).  Reset the level and gem count.  You could add
    # additional game-over UI or effects here.
    Global.gems_collected = 0
    # Delay the reload slightly to allow any death animation or
    # sound to play.  The await keyword waits for the timer to
    # complete before proceeding.  Without this delay the scene
    # reload happens immediately.
    await get_tree().create_timer(0.1).timeout
    get_tree().reload_current_scene()
