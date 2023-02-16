extends KinematicBody2D

# Child Nodes
var animationPlayer = null;

# Member vars
export var speed = 80;
export var acceleration = 200;
export var friction = 200;
export var maxSpeed = 400;
var velocity = Vector2.ZERO;

enum {
	Idle, 
	Move,
	Attack,
	Die
}

var state = null;
func _ready():
	animationPlayer = $AnimationPlayer;
	state = Idle;
	
func _process(delta):
	var movement = Vector2.ZERO;
	movement.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	movement.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	movement = movement.normalized();
	if(movement != Vector2.ZERO):
		state = Move;
	else:
		state = Idle;
	
	move_and_slide(velocity);
	
	
	match(state):
		Idle:
			animationPlayer.stop();
			velocity = velocity.move_toward(Vector2.ZERO, friction);
		Move:
			animationPlayer.play("Walk");
			velocity = velocity.move_toward(movement * speed, acceleration);
		Attack:
			pass;
		Die:
			pass;
