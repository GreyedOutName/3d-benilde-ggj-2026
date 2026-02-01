extends Node

var Evidences:Dictionary ={
	1:["He is alive","He is you"],#2
	2:["The Body was found","at 7:30 am","by the Heir"],#3
	3:["The Widow","never","saw","the Heir","call for help"],#5
	4:["The Heir","caught the Widow","giving poison"],#3
	5:["He drank poison","willingly","to end the pain"],#3
	6:["The Butler","hates","this place","if not for","the ring"],#3
	8:["The Heir","was here","during the death"],#3
	9:["The Widow","did not know","it was poison"],#3
	10:["The mansion","was never theirs"]#2
}

var Evidence_progress:Dictionary={
	1:[0,0],
	2:[0,0,0],
	3:[0,0,0,0,0],
	4:[0,0,0],
	5:[0,0,0],
	6:[0,0,0,0,0],
	8:[0,0,0],
	9:[0,0,0],
	10:[0,0],
}

var intro_text:Dictionary ={
	1:["You are here","in the world",",detective","on the scene."],
}

var intro_progress:Dictionary = {
	1:["0","0","0","0"],
}

var ending_text:Dictionary = {
	1:["The world","loves","you"],
	2:["The mansion","was happiness"],
	3:["The poison","was lies"],
	4:["The trip","was his future"],
	5:["The ring","was respect"],
	6:["The dispute","was your bigotry"],
	7:["The culprit","is you"],
	8:["The victim","is you"]
}

var ending_progress:Dictionary = {
	1:["0","0","0"],
	2:["0","0"],
	3:["0","0"],
	4:["0","0"],
	5:["0","0"],
	6:["0","0"],
	7:["0","0"],
	8:["0","0"],
}

var Inventory_State:Dictionary ={
	"Poison Bottle":false,
	"Key":false,
	"Will":false,
	"Ring":false,
	"Note":false,
}

var NPC_State:Dictionary={
	"Butler":"grey",
	"Widow":"grey",
	"Heir":"grey",
}

var has_key = false
var butler1_talked = false
var heir1_talked = false
var widow1_talked = false
