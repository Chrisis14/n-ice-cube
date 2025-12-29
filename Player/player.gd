extends CharacterBody2D

@onready var s_icey := $S_Icey
@onready var s_wat := $S_Wat

@onready var hit_icey := $Hit_Icey
@onready var hit_wat := $Hit_Wat

@export var speed: int = 400
@export var gravity: int = 4000
@export var jump_velocity: int = -1200
@export var climb_speed: int = 150

var wall_climb_enabled := false
var jal_power = false
var on_wall := false
var at_end := false

func _ready() -> void:
	add_to_group("can_interact_with_water")
	add_to_group("player")

func enable_wall_climb():
	wall_climb_enabled = true
	speed = 150
	
func enable_jal_power():
	jal_power = true
	add_to_group("immune_hot_sauce")
	remove_from_group("immune_ice")

func _physics_process(delta: float) -> void:
		# Left / Right movement
	var direction := Input.get_axis("LEFT", "RIGHT")
	velocity.x = direction * speed

		# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

		# Jump
	if Input.is_action_just_pressed("UP") and is_on_floor():
		velocity.y = jump_velocity

		# Check walls
	on_wall = is_on_wall()

	 # Wall climbing
	if wall_climb_enabled and on_wall:
	 # cancel gravity
		velocity.y = 0

		var vertical := 0.0
		if Input.is_action_pressed("UP"):
			vertical -= 1
		if Input.is_action_pressed("DOWN"):
			vertical += 1

		velocity.y = vertical * climb_speed

	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider and collider.is_in_group("plate") and Input.is_action_pressed("MELT"):
			s_icey.visible = false
			s_wat.visible = true
			
			hit_icey.disabled = true
			hit_wat.disabled = false

func _on_climbing_claws_picked_up() -> void:
	enable_wall_climb()


func _on_jalapeno_jal_picked_up() -> void:
	enable_jal_power()



func _on_hot_sauce_collision_body_entered(body: Node2D) -> void:
	if not body.is_in_group("immune_hot_sauce"):
		get_tree().reload_current_scene()


func _on_water_collision_body_entered(body: Node2D) -> void:
	if not body.is_in_group("immune_ice"):
		get_tree().reload_current_scene()
	elif s_wat.visible:
		s_icey.visible = true
		s_wat.visible = false
			
		hit_icey.disabled = false
		hit_wat.disabled = true

func _on_slow_powder_body_entered(body: Node2D) -> void:
	speed = 200


func _on_slow_powder_body_exited(body: Node2D) -> void:
	speed = 400


func _on_ice_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		at_end = true

func _on_ice_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		at_end = false
		
func _process(delta: float) -> void:
	if at_end and Input.is_action_just_pressed("NEXT_LEVEL"):
		get_tree().change_scene_to_file("res://Scenes/Level_2.tscn")
