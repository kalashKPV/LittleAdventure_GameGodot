extends Node

var score : int
var hi_score : int

var action_open_door : bool = false

var config
var path_to_save_file := "user://game.cfg"
var section_name := "game" #!!!


var deaths_n : int = 0
var kills_n : int = 0

var sound : int

var number_keys : int = 0
var number_blue_diamonds : String
var number_green_diamonds : String
var number_red_diamonds : String

var player_name : String

func _ready() -> void:	
	load_game()

func save_game() -> void:
	config.set_value(section_name, "player_name", player_name)
	config.set_value(section_name, "deaths_n", deaths_n);
	config.set_value(section_name, "kills_n", kills_n);
	config.set_value(section_name, "number_keys", number_keys)
	config.set_value(section_name, "number_blue_diamonds", number_blue_diamonds)
	config.set_value(section_name, "number_green_diamonds", number_green_diamonds)
	config.set_value(section_name, "number_red_diamonds", number_red_diamonds)
	config.set_value(section_name, "hi_score", hi_score)
	config.set_value(section_name, "score", score)
	config.set_value(section_name, "sound", sound)
	config.save(path_to_save_file)
	
func load_game() -> void:
	config = ConfigFile.new()
	config.load(path_to_save_file)
	player_name = config.get_value(section_name, "player_name", "Player")
	deaths_n = config.get_value(section_name, "deaths_n", 0)
	kills_n = config.get_value(section_name, "kills_n", 0)
	number_keys = config.get_value(section_name, "number_keys", 0)
	number_blue_diamonds = config.get_value(section_name, "number_blue_diamonds", "")
	number_green_diamonds = config.get_value(section_name, "number_green_diamonds", "")
	number_red_diamonds = config.get_value(section_name, "number_red_diamonds", "")
	hi_score = config.get_value(section_name, "hi_score", 0)
	score = config.get_value(section_name, "score", 0)
	sound = config.get_value(section_name, "sound", 100)
