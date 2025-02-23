extends Node

class_name GameManager

@export var player_lifes = 2
const PLAYER_SCENE = preload("res://Scenes/player.tscn")

@onready var phantom_camera_2d: PhantomCamera2D = $PhantomCamera2D
@onready var ui: UI = $UI
@onready var player: Player = $Player

@onready var bridges: Node = $Bridges

var player_spawn_point = Vector2(-2, 40.0)

func _ready() -> void:
	var bride_nodes = bridges.get_children()  as Array[Bridge]
	for bridge in bride_nodes:
		bridge.set_new_spawn_point.connect(on_set_new_spawn_point)

	ui.apply_lifes(player_lifes)
	player.connect("tree_exited", on_player_tree_exited)
	
func on_set_new_spawn_point(spawn_point: Vector2):
	player_spawn_point = spawn_point

func on_player_tree_exited():
	player_lifes -= 1
	if player_lifes == 0:
		ui.game_over_view.show()
	else: 
		respawn_player()
		ui.apply_lifes(player_lifes)

func respawn_player():
	player = PLAYER_SCENE.instantiate()
	get_tree().root.get_node("main").add_child(player)
	player.global_position = player_spawn_point
	phantom_camera_2d.follow_target = player
	player.connect("tree_exited", on_player_tree_exited)


	
	
	
