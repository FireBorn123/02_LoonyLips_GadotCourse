extends Node2D


var player_words = [] # the words that the player chooses to use
var game_text # All of the text that's displayed to the player
var current_story

func _ready():
	set_random_story()
	game_text = get_from_json("other_strings.json")
	$Blackboard/StoryText.bbcode_text = (game_text.begin_game_text)
	prompt_player()
	$Blackboard/TextBox.clear()

func set_random_story():
	var stories = get_from_json("stories.json")
	randomize()
	current_story = stories[randi() % stories.size()]

func get_from_json(filename):
	var file= File.new() #the file object
	file.open(filename, File.READ) #Assumes file exsits
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data

func is_story_done(): # Return if story is finished
	return player_words.size() == current_story.prompt.size() 
	
func _on_TextureButton_pressed():
	if is_story_done():
			get_tree().reload_current_scene()
	else:
		var new_text = $Blackboard/TextBox.get_text()
		_on_TextBox_text_entered(new_text)

func _on_TextBox_text_entered(new_text):
	player_words.append(new_text)
	$Blackboard/TextBox.clear()
	$Blackboard/StoryText.clear()
	check_player_word_length()

func prompt_player():
	var next_prompt = current_story.prompt[player_words.size()]
	$Blackboard/StoryText.bbcode_text += (game_text.game_prompt % next_prompt)


func check_player_word_length():
	if is_story_done():
		tell_story()
	else:
		prompt_player()

func tell_story():
	$Blackboard/StoryText.bbcode_text = current_story.story % player_words
	$Blackboard/TextureButton/RichTextLabel.text = game_text.end_game_text
	end_game()

func end_game():
	$Blackboard/TextBox.queue_free()