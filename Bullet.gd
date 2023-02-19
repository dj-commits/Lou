extends KinematicBody2D

var velocity: Vector2;
export var bulletSpeed: float;
func _ready():
	pass;

func _process(delta):
	velocity += velocity * delta;
	var collision;
	collision = move_and_collide(velocity);
	if(collision != null):
		if(collision.collider.name != "Player"):
			queue_free();
