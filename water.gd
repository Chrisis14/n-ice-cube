@tool
extends Node2D
class_name Water
@export_range(2, 512)
var segment_count: int = 64

@export var water_size: Vector2 = Vector2(256, 64)
@export var surface_pos_y: float = 0.0

@export var surface_line_thickness: float = 2.0
@export var surface_color: Color = Color.html("#2e6ed5")
@export var fill_color: Color = Color.html("#054976")

var surface_line: Line2D
var fill_polygon: Polygon2D

@export_tool_button("Update_Water")
var update_water_button := func():
	update_water()


func _ready():
	_make_nodes()
	update_water()
	
func _on_body_entered(body):
	if not body.is_in_group("player"):
		body.queue_free()

func _make_nodes():
	# Remove old if regenerating
	if surface_line and surface_line.is_inside_tree():
		surface_line.queue_free()

	# Surface line
	surface_line = Line2D.new()
	surface_line.width = surface_line_thickness
	surface_line.default_color = surface_color
	add_child(surface_line)

	# Fill polygon
	fill_polygon = Polygon2D.new()
	fill_polygon.color = fill_color
	fill_polygon.show_behind_parent = true
	surface_line.add_child(fill_polygon)


func update_water():
	_update_mesh()


func _update_mesh():
	var pts: Array[Vector2] = []

	# Create evenly-spaced flat surface
	for i in range(segment_count):
		var x := float(i) / float(segment_count - 1) * water_size.x
		var y := surface_pos_y
		pts.append(Vector2(x, y))

	# Apply to line
	surface_line.points = pts

	# Build polygon (surface + bottom corners)
	var poly := pts.duplicate()
	poly.append(Vector2(water_size.x, water_size.y))
	poly.append(Vector2(0.0, water_size.y))

	fill_polygon.polygon = poly
