extends Node

var levels = [
	"res://Scenes/level_1.tscn",
	"res://Scenes/level_2.tscn",
	"res://Scenes/level_3.tscn",
	"res://Scenes/level_4.tscn",
	"res://Scenes/level_5.tscn",
	"res://Scenes/level_6.tscn",
	"res://Scenes/level_7.tscn",
	"res://Scenes/level_8.tscn",
	"res://Scenes/level_9.tscn",
	"res://Scenes/level_10.tscn",
	"res://Scenes/level_11.tscn",
	"res://Scenes/level_12.tscn",
	"res://Scenes/level_13.tscn",
	"res://Scenes/level_14.tscn",
	"res://Scenes/level_15.tscn",
]

var current_level_index := 0

func load_current_level():
	print("Loading level index:", current_level_index)
	get_tree().change_scene_to_file(levels[current_level_index])

func load_next_level():
	current_level_index += 1
	print("Next level index:", current_level_index)
	if current_level_index < levels.size():
		load_current_level()
	else:
		print("Game finished!")  # or load a win screen
