extends Area2D

class_name PowerStation

signal apply_points_to_ui(points: int)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func explode():
	animated_sprite_2d.play("explosion")
	apply_points_to_ui.emit(150)
	audio_stream_player.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "explosion":
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	(body as Player).get_node("PowerSystem").start_power_increase()
		


func _on_body_exited(body: Node2D) -> void:
	(body as Player).get_node("PowerSystem").stop_power_increase()
