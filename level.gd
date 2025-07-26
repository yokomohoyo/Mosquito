extends Node2D

@export var level_num = 0

var Mosquito: PackedScene = preload("res://mosquito.tscn")

func _ready():
	$HUD.level(level_num)
	set_gems_label()
	spawn_mosquito()
	for gem in $Gems.get_children():
		gem.gem_collected.connect(_on_gem_collected)

func _on_gem_collected():
	set_gems_label()

func set_gems_label():
	$HUD.gems(Global.gems_collected)

func _on_door_player_entered(level):
	get_tree().change_scene_to_file(level)

func _input(event):
	if event.is_action_pressed("reset_level"):
		get_tree().reload_current_scene.call_deferred()
		Global.gems_collected = 0
		set_gems_label()


func spawn_mosquito():
	var mosquito = Mosquito.instantiate()
	mosquito.global_position = Vector2(randi_range(100, 600), randi_range(100, 350))
	mosquito.target = $Player
	add_child(mosquito)
