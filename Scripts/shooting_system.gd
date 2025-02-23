extends Node2D

class_name ShootingSystem

const MISSLE_SCENE = preload("res://Scenes/missle.tscn")

@onready var missle_spawn_point: Marker2D = $MissleSpawnPoint
@onready var shooting_stream_player: AudioStreamPlayer = $ShootingStreamPlayer

var can_shoot = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot") && can_shoot:
		var missle = MISSLE_SCENE.instantiate()
		missle.global_position = missle_spawn_point.global_position
		get_tree().root.add_child(missle)
		missle.tree_exited.connect(on_missle_destroyed)
		can_shoot = false
		shooting_stream_player.play()

func on_missle_destroyed():
	can_shoot = true
		
