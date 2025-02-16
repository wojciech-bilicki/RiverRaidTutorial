extends CharacterBody2D

class_name Player 
#region Child nodes
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#endregion

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
	elif Input.is_action_pressed("decelerate"):
		velocity.y = min(velocity.y + deceleration * delta, -min_speed)
	elif velocity.y < 0:
		velocity.y = min(velocity.y + air_resistance * delta, -min_speed)
		
	#endregion
	move_and_slide()
