extends Node2D

@export var level_num = 0

var Mosquito = preload("res://mosquito.tscn")

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
    # Randomly spawn one or more mosquitos depending on the current
    # level.  Higher levels spawn more enemies to gently ramp the
    # difficulty.  This method randomizes the spawn points within a
    # reasonable range so that mosquitos appear in different places
    # each time the level is loaded or reset.
    randomize()
    var count := max(1, int(level_num) + 1)
    for i in range(count):
        var mosquito = Mosquito.instance()
        # Choose a random position within the level bounds.  These
        # values may be adjusted based on your level size.  The Y
        # coordinate is clamped so that mosquitos spawn near the
        # playable area rather than off-screen.
        var x_pos := randf_range(100.0, 900.0)
        var y_pos := randf_range(50.0, 450.0)
        mosquito.global_position = Vector2(x_pos, y_pos)
        mosquito.target = $Player
        add_child(mosquito)
