extends CharacterBody2D

class_name Player 


@export_group("Sounds")
@export var thurst_start_stream: AudioStream
@export var thurst_loop_stream: AudioStream
@export var thurst_end_stream: AudioStream
@export var explosion_sound: AudioStream
@export_group("")

#region Child nodes
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var power_system: PowerSystem = $PowerSystem
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
#endregion

var played_start_once = false
var played_end_once = false

#region Player movement variables
@export_group("Movement")
@export var acceleration: float = 500
@export var deceleration: float = 400
@export var max_speed: float = 200
@export var min_speed: float = 50

@export var air_resistance: float = 100
@export_group("")

#endregion

func _physics_process(delta: float) -> void:
	#region Collision check
	var collision = get_last_slide_collision()
	
	if collision != null:
		explode()
		return
	
	#endregion
	
	
	#region Horizontal movement
	if Input.is_action_pressed("right"):
		velocity.x = min(velocity.x + acceleration * delta, max_speed)
			
		if animated_sprite_2d.animation != "right":
			animated_sprite_2d.play("right")
		
	elif Input.is_action_pressed("left"):
		velocity.x = max(velocity.x - acceleration*delta, -max_speed)
		if animated_sprite_2d.animation != "left":
			animated_sprite_2d.play("left")
		
	else: 
		if animated_sprite_2d.animation != "default":
			animated_sprite_2d.play("default")
		velocity.x = move_toward(velocity.x, 0, delta * air_resistance)
	#endregion
	
	#region Vertical movement
	if Input.is_action_pressed("accelerate"):
		velocity.y = max(velocity.y - acceleration * delta, -max_speed)
		if !played_start_once:
			played_start_once = true
			play_sound(thurst_start_stream)
	elif Input.is_action_pressed("decelerate"):
		velocity.y = min(velocity.y + deceleration * delta, -min_speed)
		if !played_end_once && played_end_once:
			play_sound(thurst_end_stream)
			played_end_once = true
			
	elif velocity.y < 0:
		velocity.y = min(velocity.y + air_resistance * delta, -min_speed)
		
	#endregion
	move_and_slide()


func explode():
	animated_sprite_2d.play("explode")
	animated_sprite_2d.modulate = Color.CRIMSON
	set_physics_process(false)
	velocity = Vector2.ZERO
	power_system.stop_timers()
	audio_stream_player.stream = explosion_sound
	audio_stream_player.play()
	

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "explode":
		queue_free()

func play_sound(stream: AudioStream):
	if audio_stream_player.playing:
		audio_stream_player.stop()
	
	audio_stream_player.stream = stream
	audio_stream_player.play()
	
func _on_audio_stream_player_finished() -> void:
	if audio_stream_player.stream == thurst_start_stream:
		play_sound(thurst_loop_stream)
	
	if audio_stream_player.stream == thurst_end_stream:
		played_end_once = false
		played_start_once = false
