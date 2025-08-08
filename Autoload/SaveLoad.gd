extends Node

func SaveHighScore(score):
	var file = ConfigFile.new()
	file.set_value("score", "highscore", score)
	file.save("user://userscore.cfg")

func LoadScore():
	var file = ConfigFile.new()
	var err = file.load("user://userscore.cfg")
	if err == OK:
		return file.get_value("score", "highscore", 0)
	return 0


