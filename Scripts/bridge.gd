extends Area2D

class_name Bridge

signal destroyed
signal set_new_spawn_point(spawn_point: Vector2)
signal apply_points_to_ui(points: int)

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var animated_sprites = [
	$AnimatedSprite2D,
	$AnimatedSprite2D2,
	$AnimatedSprite2D3,
	$AnimatedSprite2D4
] as Array[AnimatedSprite2D]

var is_destroyed = false

func _ready() -> void:
	for animated_sprite in animated_sprites:
		(animated_sprite as AnimatedSprite2D).connect("animation_finished", func():  if animated_sprite.animation == "explode": animated_sprite.hide()  )


func explode():
	for animated_sprite in animated_sprites:
		animated_sprite.modulate = Color.FIREBRICK
		animated_sprite.play("explode")
	
	apply_points_to_ui.emit(125)
	destroyed.emit()
	is_destroyed = true
	audio_stream_player.play()
	
	
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if !is_destroyed:
			(body as Player).explode()
			
		else: 
			set_new_spawn_point.emit(self.position)


func _on_area_entered(area: Area2D) -> void:
	if area is Missle:
		explode()
		set_collision_mask_value(3, false)
