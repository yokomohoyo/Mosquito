extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var buzz: AudioStreamPlayer = $"AnimatedSprite2D/Buzz"

var target: Node2D
var speed: float = 100.0
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	var tex: Texture2D = load("res://mosquito_blue_sheet.png")
	var frames: SpriteFrames = SpriteFrames.new()
	frames.add_animation("default")
	frames.set_animation_loop("default", true)

	var frame_w: int = 16
	var frame_h: int = 16
	var count: int = 4

	for i in range(count):
		var atlas: AtlasTexture = AtlasTexture.new()
		atlas.atlas = tex
		atlas.region = Rect2(i * frame_w, 0, frame_w, frame_h)
		frames.add_frame("default", atlas)

	if buzz != null:
		var buzz_stream: AudioStream = preload("res://mosquito_buzz.ogg")
		if buzz_stream is AudioStreamOggVorbis:
			(buzz_stream as AudioStreamOggVorbis).loop = true
		buzz.stream = buzz_stream
		buzz.volume_db = -10.0
		if not buzz.playing:
			buzz.play()

	anim.sprite_frames = frames
	anim.play("default")


func _physics_process(delta: float) -> void:
	if target != null:
		var dir: Vector2 = (target.global_position - global_position).normalized()
		velocity = velocity.move_toward(dir * speed, 400.0 * delta)
		global_position += velocity * delta
		anim.flip_h = velocity.x < 0.0
		anim.speed_scale = clamp(0.8 + velocity.length() / (speed * 2.0), 0.8, 1.4)

	if buzz == null:
		push_warning("Buzz node not found at AnimatedSprite2D/Buzz")
		return

	if target != null and buzz != null:
		var d: float = global_position.distance_to(target.global_position)
		var t: float = clamp(1.0 - d / 600.0, 0.0, 1.0)
		buzz.volume_db = lerp(-18.0, -3.0, t)
		if not buzz.playing:
			buzz.play()

func _on_body_entered(body: Node) -> void:
	if body != null and body.has_method("die"):
		body.call_deferred("die")
		queue_free()
