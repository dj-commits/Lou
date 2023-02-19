extends KinematicBody2D

onready var sprite = $Sprite;
onready var animationPlayer = $AnimationPlayer;
onready var hitbox = $Hitbox;
onready var hurtbox = $Hurtbox;

enum BehaviorState{
	Idle, 
	Move
}
var state;

func _ready():
	state = BehaviorState.Idle;

func _physics_process(delta):
	animationPlayer.play("Float");
