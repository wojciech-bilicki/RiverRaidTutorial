extends CanvasLayer

class_name UI

@export var min_power_indicator_x_pos: float
@export var max_power_indicator_x_pos: float
@export var power_decrease_factor:float = 1

@onready var power_indicator: TextureRect = $ControlPanelRect/PowerIndicator
@onready var points_label: Label = $ControlPanelRect/PointsLabel
@onready var lifes_label: Label = $ControlPanelRect/LifesLabel
@onready var game_over_view: CenterContainer = $GameOverView

var total_points = 0
var power_indicator_x_pos: float

func _ready() -> void:
	power_indicator_x_pos = max_power_indicator_x_pos
	var entities_with_points = get_tree().get_nodes_in_group("with_points")
	for entity in entities_with_points:
		entity.apply_points_to_ui.connect(on_apply_points)
	points_label.text = "Points: %d" % total_points
	
func setup_power(max_power: float):
	power_decrease_factor = (max_power_indicator_x_pos - min_power_indicator_x_pos) / max_power
	
func change_power_indicator(direction: Vector2, tween_time: float):
	var tween = create_tween()
	tween.tween_property(power_indicator, "position", direction * power_decrease_factor, tween_time).from_current().as_relative()
	print(power_decrease_factor)

func show_game_over_screen():
	game_over_view.show()

func on_apply_points(points):
	total_points += points
	points_label.text = "Points %d" % total_points
	
func apply_lifes(lifes: int):
	lifes_label.text = "Lifes %d" % lifes
	
	
