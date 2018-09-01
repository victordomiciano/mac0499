extends Node2D

onready var creeps = get_node('../Creeps')
onready var wave_manager = get_node('../WaveManager')

func _ready():
	for spawner in self.get_children():
		spawner.get_node('Timer').connect('timeout', self, 'spawn_creep', [spawner])

func spawn_creep(spawner):
	if wave_manager.cur_points <= wave_manager.wave_points:
		randomize()
		var creep_idx = randi() % creeps.CREEPS.size()
		var creep = creeps.CREEPS[creep_idx].instance()
		creep.offset = Vector2(-40 + randi() % 81, -30 + randi() % 61)
		creep.position = spawner.position + creep.offset
		creep.spawner = spawner
		creeps.add_child(creep)
		wave_manager.cur_points += creep.value
	else:
		for spawner in self.get_children():
			spawner.get_node('Timer').stop()
		wave_manager.end_wave()

func start_wave():
	for spawner in self.get_children():
		spawner.get_node('Timer').start()
