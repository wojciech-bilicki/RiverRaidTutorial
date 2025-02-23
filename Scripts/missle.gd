extends Area2D

class_name Missle

@export var missle_speed = 400

func _process(delta: float) -> void:
	position.y -= missle_speed * delta

func _on_body_entered(body: Node2D) -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		(area as Enemy).explode()
	if (area is PowerStation):
		(area as PowerStation).explode()	
	
	queue_free()
