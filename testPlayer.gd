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
var aimDirection: Vector2;
var mousePos: Vector2;
var shooting: bool;
var interacting: bool;

enum BehaviorState {
	Idle, 
	Move,
	Interacting
}

var state;

func _ready():
	state = BehaviorState.Idle;
	
func _process(delta):
	
	mousePos = get_global_mouse_position();
	aimDirection = global_position.direction_to(mousePos);
	playerGun.global_rotation = aimDirection.angle();
	
	var movement = Vector2.ZERO;
	movement.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	movement.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	movement = movement.normalized();
	if(Input.is_action_just_pressed("interact")):
		if(interacting):
			interacting = false;
		else:
			interacting = true;
	if(Input.is_action_just_pressed("attack") && !interacting):
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
				shoot(aimDirection);
		BehaviorState.Move:
			animationPlayer.play("Walk");
			velocity = velocity.move_toward(movement * speed, acceleration * delta);
			if(shooting):
				shoot(aimDirection);
		BehaviorState.Interacting:
			velocity = Vector2.ZERO;
			
func shoot(var direction: Vector2):
	var centerBullet = regularBullet.instance();
	var leftBullet = regularBullet.instance();
	var rightBullet = regularBullet.instance();
	get_tree().get_current_scene().add_child(centerBullet);
	get_tree().get_current_scene().add_child(leftBullet);
	get_tree().get_current_scene().add_child(rightBullet);
	
	centerBullet.global_position = playerGun.gunEnd.global_position;
	centerBullet.velocity = direction;
	leftBullet.global_position = playerGun.gunEnd.global_position;
	leftBullet.velocity = direction.rotated(deg2rad(-15));
	rightBullet.global_position = playerGun.gunEnd.global_position;
	rightBullet.velocity = direction.rotated(deg2rad(15));
	
	shooting = false;


func _on_WarpToHallway_body_entered(body):
	get_tree().change_scene("res://World/Hallway.tscn"); # Replace with function body.
