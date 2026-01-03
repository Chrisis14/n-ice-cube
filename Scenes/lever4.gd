extends Area2D

@onready var platform_visual_1 := $"../StaticBody2D/Color_Plat"
@onready var platform_collision_1 := $"../StaticBody2D/Platform_Col"

var player_inside := false
var is_on := true


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false


func _process(delta):
	if player_inside and Input.is_action_just_pressed("MELT"):
		_toggle_platform()


func _toggle_platform():
	is_on = !is_on   # flip it
	platform_visual_1.visible = !is_on
	platform_collision_1.disabled = is_on
