extends Node
class_name PlayerState #luokka eri pelaajan tiloille

var player #viite pelaajaan


func enterState(playerNode):
	player = playerNode

func exitState():
	pass
	
func handleInput(_delta):
	pass
	
