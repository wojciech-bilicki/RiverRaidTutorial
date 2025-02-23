extends Node

class_name PowerSystem

var max_power = 30
var min_power = 0
var current_power

@onready var ui:UI = $"/root/main/UI"

@onready var power_decrease_timer: Timer = $PowerDecreaseTimer
@onready var power_increase_timer: Timer = $PowerIncreaseTimer


func _ready() -> void:
	current_power = max_power
	ui.setup_power(max_power)

func _on_power_decrease_timer_timeout() -> void:
	current_power -= 1
	print(current_power)
	ui.change_power_indicator(Vector2.LEFT, power_decrease_timer.wait_time)
	
	if current_power == 0:
		(get_parent() as Player).explode()


func _on_power_increase_timer_timeout() -> void:
	if current_power < max_power:
		current_power += 1
		ui.change_power_indicator(Vector2.RIGHT, power_increase_timer.wait_time)

func stop_timers():
	power_decrease_timer.stop()
	power_increase_timer.stop()


func start_power_increase():
	power_increase_timer.start()
	power_decrease_timer.stop()
	
func stop_power_increase():
	power_decrease_timer.start()
	power_increase_timer.stop()	
