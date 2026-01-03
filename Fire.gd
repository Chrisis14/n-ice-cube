extends CharacterBody2D

@export var speed := 330
@export var gravity := 400
@export var chase_range := 150
@export var jump_force := -330      
@export var jump_cooldown := 0.6    
var can_jump := true

var player
var direction := 1


func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func jump():
	if can_jump and is_on_floor():
		velocity.y = jump_force
		can_jump = false
		await get_tree().create_timer(jump_cooldown).timeout
		can_jump = true


func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Distance to player
	var dist = global_position.distance_to(player.global_position)

	# Chase when close
	if dist < chase_range:
		velocity.x = sign(player.global_position.x - global_position.x) * speed
	else:
		velocity.x = direction * speed

	# If wall ahead -> jump instead of turning
	if is_on_wall():
		jump()                     # try to jump forward
		direction *= -1            # OPTIONAL — remove this if you want them to keep direction

	# Handle collisions (player kill logic)
	for i in range(get_slide_collision_count()):
		var col = get_slide_collision(i)
		var body = col.get_collider()
		if body.is_in_group("player") and not body.jal_power:    
			var tree = get_tree()
			if tree and tree.current_scene:
				tree.reload_current_scene()

	move_and_slide()
