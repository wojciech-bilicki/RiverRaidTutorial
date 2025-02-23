extends Area2D

class_name Enemy

signal apply_points_to_ui(points: int)

@export var enemy_config: EnemyConfig
@export var switch_starting_direction: bool

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


var speed = 50
var direction = 1
var should_move = true

func _ready() -> void:
	collision_shape_2d.shape = enemy_config.enemy_collision_shape
	if switch_starting_direction:
		scale.x = -1
	
	animated_sprite_2d.play(enemy_config.enemy_type)
	
	if enemy_config.enemy_type == "jet":
		set_collision_mask_value(2, false)
	
	speed = enemy_config.speed

func _process(delta: float) -> void:
	if should_move:
		position.x += speed * delta * direction

func explode():
	should_move = false
	animated_sprite_2d.modulate = enemy_config.explosion_color
	animated_sprite_2d.play("explosion")
	apply_points_to_ui.emit(enemy_config.points)
	audio_stream_player.play()


func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		scale.x *= -1
		direction *= -1
	
	if body is Player:
		explode()
		(body as Player).explode()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "explosion":
		queue_free()
