extends Control

const DEFAULT_CONFIG_BITCOIN : String = '''# Generated by cusf_launcher
rpcuser=user
rpcpassword=password
signetblocktime=60
signetchallenge=00141f61d57873d70d28bd28b3c9f9d6bf818b5a0d6a
zmqpubsequence=tcp://0.0.0.0:29000
txindex=1
server=1
'''

signal configuration_complete


func get_bitcoin_datadir() -> String:
	var user : String = get_username()
	
	match OS.get_name():
		"Linux":
			return str("/home/", user, "/.bitcoin")
		"Windows":
			return str("C:\\Users\\", user, "\\AppData\\Roaming\\Bitcoin")
		"macOS":
			return str("/home/", user, "/Library/Application Support/Bitcoin/")
	
	return ""


func get_username() -> String:
	var user : String = ""
	if OS.has_environment("USERNAME"):
		# Windows
		user = OS.get_environment("USERNAME")
	elif OS.has_environment("USER"):
		# Everything else
		user = OS.get_environment("USER")
	
	return user


func have_bitcoin_configuration() -> bool:
	if FileAccess.file_exists(str(get_bitcoin_datadir(), "/bitcoin.conf")):
		configuration_complete.emit()
		return true
	
	return false
	

func write_bitcoin_configuration() -> void:
	DirAccess.make_dir_absolute(get_bitcoin_datadir())
	
	var file = FileAccess.open(str(get_bitcoin_datadir(), "/bitcoin.conf"), FileAccess.WRITE_READ)
	file.store_string(DEFAULT_CONFIG_BITCOIN)
	
	configuration_complete.emit()
