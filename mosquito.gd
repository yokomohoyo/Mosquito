extends Area2D

var target = null
var speed = 200
var velocity = Vector2.ZERO

func _ready():
    # Adding the mosquito to an "enemies" group makes it easier to
    # reference all enemies at once (e.g. for cleanup or group
    # interactions).  Other scripts can use get_tree().get_nodes_in_group()
    # to access all enemies.
    add_to_group("enemies")

func _physics_process(delta):
	if target:
		# Smooth "gravity-like" movement toward the player
		var direction = (target.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * speed, 400 * delta)
		global_position += velocity * delta

func _on_body_entered(body):
    if body and body.has_method("die"):
        # Invoke the player's death routine when colliding with the
        # mosquito.  After dealing damage the mosquito removes
        # itself from the scene to prevent additional collisions.
        body.die()
        queue_free()
