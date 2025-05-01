extends Node
const VERSION = "1.1 Release"

signal state_changed(key, value)

var has_met_sara = false
var has_met_li = false

var PLAYER_NAME: String = ""

var states_dict: Dictionary = {
	"ufq": -1, 
	"denizens_talked": 0, 
	"doorman": -1, 
	"merch_egg": 0,
	"milf_feather": 0,
	"didi_feather": 0
	}

var num_denizens = 13

var player_feathers: int = 0



func set_state(key, entry):
	states_dict[key] = entry
	state_changed.emit(key, entry)
