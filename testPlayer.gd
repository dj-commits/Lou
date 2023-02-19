extends KinematicBody2D

# Child Nodes
onready var animationPlayer = $AnimationPlayer;
onready var playerGun = $PlayerGun;
var regularBullet = preload("res://Bullet.tscn");

# Member vars
export var speed = 80;
export var acceleration = 200;
export var friction = 200;
export var maxSpeed = 400;
var velocity: Vector2;
var direction: Vector2;
var mousePos: Vector2;
var shooting: bool;


enum BehaviorState {
	Idle, 
	Move,
}

var state;

func _ready():
	state = BehaviorState.Idle;
	
func _process(delta):
	mousePos = get_global_mouse_position();
	direction = mousePos - position;
	playerGun.rotation = direction.angle();
	
	var movement = Vector2.ZERO;
	movement.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	movement.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	movement = movement.normalized();
	
	if(Input.is_action_just_pressed("attack")):
		shooting = true;
	if(movement != Vector2.ZERO):
		state = BehaviorState.Move;
	else:
		state = BehaviorState.Idle
	
	move_and_slide(velocity);
	match(state):
		BehaviorState.Idle:
			animationPlayer.stop();
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta);
			if(shooting):
				shoot(regularBullet);
		BehaviorState.Move:
			animationPlayer.play("Walk");
			velocity = velocity.move_toward(movement * speed, acceleration * delta);
			if(shooting):
				shoot(regularBullet);
			
func shoot(var bullet):
	var centerBullet = bullet.instance();
	var leftBullet = bullet.instance();
	var rightBullet = bullet.instance();
	get_tree().get_current_scene().add_child(centerBullet);
	get_tree().get_current_scene().add_child(leftBullet);
	get_tree().get_current_scene().add_child(rightBullet);
	var tempDirection = direction.normalized();
	var tempVelocity = tempDirection * rand_range(.8, 2);
	centerBullet.position = playerGun.global_position + direction / 2.5
	centerBullet.velocity = tempVelocity
	leftBullet.position = Vector2((playerGun.global_position.x + direction.x / 2.5) + rand_range(-8, -30),
								  (playerGun.global_position.y + direction.y / 2.5) + rand_range(2, 4));
	leftBullet.velocity = tempVelocity;
	rightBullet.position = Vector2((playerGun.global_position.x + direction.x / 2.5) + rand_range(8, 30),
								  (playerGun.global_position.y + direction.y / 2.5) + rand_range(2, 4));
	rightBullet.velocity = tempVelocity;
	shooting = false;
