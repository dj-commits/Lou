extends ColorRect


export var dialogPath = "res://Assets/DialogueFiles/IntroDialogue.json";
export(float) var textSpeed = 0.05;

var dialog;
var phraseNum: int;
var finished: bool;
var control;


signal dialog_finished;

func _ready():
	control = get_parent();
	$Timer.wait_time = textSpeed;
	dialog = getDialog();
	assert(dialog, "Dialog not found");
	
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
	
func nextPhrase():
	if(control.visible == false):
		control.visible = true;
	if(phraseNum) >= len(dialog):
		emit_signal("dialog_finished");
		return
	
	$Name.bbcode_text = dialog[phraseNum]["Name"];
	$Text.bbcode_text = dialog[phraseNum]["Text"];
	$Text.visible_characters = 0;
	
	while($Text.visible_characters < len($Text.text)):
		$Text.visible_characters += 1;
		$Timer.start();
		yield($Timer, "timeout");
	finished = true;
	phraseNum += 1;
	return;
