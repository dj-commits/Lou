extends ColorRect


export var dialogPath = "res://Assets/DialogueFiles/IntroDialogue.json";
export(float) var textSpeed = 0.05;

onready var nameText = $Name;
onready var textText = $Text;
var dialog;
var phraseNum: int;
var finished: bool;
var control;
var talking: bool;


signal dialog_finished;

func _ready():
	control = get_parent();
	$Timer.wait_time = textSpeed;
	dialog = getDialog();
	assert(dialog, "Dialog not found");
	
func _process(delta):
	if(Input.is_action_just_pressed("interact") && textText.percent_visible != 1 && phraseNum != 0):
		skipDialog();

func getDialog() -> Array:
	var f = File.new();
	assert(f.file_exists(dialogPath), "File path does not exist");
	f.open(dialogPath, File.READ);
	var json = f.get_as_text();
	
	var output = parse_json(json);
	if(typeof(output) == TYPE_ARRAY):
		return output;
	else:
		return[];

func resetDialog():
	control.visible = false;
	phraseNum = 0;
	
func skipDialog():
	phraseNum += 1;
	nextPhrase();
	
func nextPhrase():
	if(control.visible == false):
		control.visible = true;
	if(phraseNum >= len(dialog)):
		emit_signal("dialog_finished");
		return
	
	$Name.bbcode_text = dialog[phraseNum]["Name"];
	$Text.bbcode_text = dialog[phraseNum]["Text"];
	$Text.visible_characters = 0;
	
	while($Text.visible_characters < len($Text.text)):
		$Text.visible_characters += 1;
		$Timer.start();
		yield($Timer, "timeout");
	
	if($Text.visible_characters == len($Text.text)):
		phraseNum += 1;
