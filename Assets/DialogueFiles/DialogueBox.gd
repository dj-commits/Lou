extends ColorRect


export var dialogPath = "res://Assets/DialogueFiles/IntroDialogue.json";
export(float) var textSpeed = 0.05;

var dialog;
var phraseNum: int;
var finished: bool;

func _ready():
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

func nextPhrase():
	if(phraseNum) >= len(dialog):
		queue_free()
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
