extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var buzz: AudioStreamPlayer = $Buzz

var target: Node2D
var speed := 200.0
var velocity := Vector2.ZERO

func _ready() -> void:
	var tex: Texture2D = load("res://mosquito_blue_sheet.png")
	var frames := SpriteFrames.new()
	frames.add_animation("default")
	frames.set_animation_loop("default", true)

	var frame_w := 16
	var frame_h := 16
	var count := 4  # number of frames in the sheet

	for i in range(count):
		var atlas := AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = Rect2(i * frame_w, 0, frame_w, frame_h)
		frames.add_frame("default", atlas)

	anim.sprite_frames = frames
	anim.play("default")

func _physics_process(delta: float) -> void:
	if target:
		var dir := (target.global_position - global_position).normalized()
		velocity = velocity.move_toward(dir * speed, 400.0 * delta)
		global_position += velocity * delta

		anim.flip_h = velocity.x < 0.0

		anim.speed_scale = clamp(0.8 + velocity.length() / (speed * 2.0), 0.8, 1.4)

		if buzz:
			var d := global_position.distance_to(target.global_position)
			buzz.volume_db = lerp(-24.0, -6.0, clamp(1.0 - d / 300.0, 0.0, 1.0))
			if not buzz.playing: buzz.play()

func _on_body_entered(body: Node) -> void:
	if body and body.has_method("die"):
		body.call_deferred("die")
		queue_free()
