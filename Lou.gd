extends KinematicBody2D

onready var sprite = $Sprite;
onready var animationPlayer = $AnimationPlayer;
onready var hitbox = $Hitbox;
onready var hurtbox = $Hurtbox;
onready var interactionZone = $InteractionZone;
onready var dialogueControl = $DialogControl;
onready var nextPhraseTimer = $NextPhraseTimer;
onready var interactControl = $InteractControl;
var player = null;

enum BehaviorState{
	Idle, 
	Move
}
var state;

func _ready():
	state = BehaviorState.Idle;
	nextPhraseTimer.wait_time = .5;

func _process(delta):
	if(player != null && Input.is_action_just_pressed("interact")):
		if(interactControl.visible):
			interactControl.visible = false;
		process_dialogue(player);
	animationPlayer.play("Float");

func process_dialogue(body: Node):
	dialogueControl.dialogueBox.nextPhrase();
		

func _on_InteractionZone_body_entered(body):
	interactControl.visible = true;
	if(body.name == "Player"):
		player = body;
		

		


func _on_InteractionZone_body_exited(body):
	if(dialogueControl.visible == true):
		dialogueControl.visible = false;
	player = null;
	dialogueControl.dialogueBox.resetDialog();


func _on_Dialogue_Box_dialog_finished():
	dialogueControl.dialogueBox.resetDialog(); # Replace with function body.
