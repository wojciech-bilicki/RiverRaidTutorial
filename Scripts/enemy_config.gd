extends Resource

class_name EnemyConfig

@export var enemy_collision_shape: RectangleShape2D
@export_enum("ship", "jet", "helicopter") var enemy_type: String = "ship"
@export var explosion_color: Color
@export var speed: float = 50
@export var points: int = 75
