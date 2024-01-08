-- sets up the following tables for murdurr
-- [Game, Player, Murder, Achievement, AchievementProgress, Location, Admin]

-- stolen from game.py
CREATE TABLE IF NOT EXISTS game (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	year INTEGER NOT NULL,
	number INTEGER NOT NULL,
	disabled BOOL DEFAULT false,
	UNIQUE (year, number)
)


-- stolen from player.py
CREATE TABLE IF NOT EXISTS player (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	game INTEGER NOT NULL references game (id),
	name STRING NOT NULL,
	ncss_group STRING NOT NULL,
	type STRING NOT NULL,
	code STRING NOT NULL,
	UNIQUE (game, name)
)

-- stolen from murder.py
CREATE TABLE IF NOT EXISTS murder (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	game INTEGER NOT NULL references game (id),
	murderer INTEGER NOT NULL references player (id),
	victim INTEGER NOT NULL references player (id),
	datetime DATETIME NOT NULL,
	location INTEGER references location(id),
	UNIQUE (murderer, victim)
)


-- stolen from achievements.py
CREATE TABLE IF NOT EXISTS achievement (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name STRING NOT NULL,
	description STRING NOT NULL,
	points INTEGER,
	goal INTEGER,
	unit STRING,
	UNIQUE (name)
)

CREATE TABLE IF NOT EXISTS achievement_progress (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	achievement INTEGER NOT NULL references achievement (id),
	player INTEGER NOT NULL references player (id),
	progress INTEGER DEFAULT 0,
	completed INTEGER DEFAULT 0
)


-- stolen from Location.py
CREATE TABLE IF NOT EXISTS location (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name INTEGER NOT NULL references game (id),
	lat DECIMAL(9,6),
	lng DECIMAL(9,6)
)

-- stolen from admin.py 
CREATE TABLE IF NOT EXISTS admin (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT(40) NOT NULL
	password TEXT(256) NOT NULL,
	UNIQUE (name)
)

