CREATE TABLE ap (
	mac CHAR(12) NOT NULL PRIMARY KEY,
	ap_key VARCHAR(255) NOT NULL UNIQUE,
	is_active TINYINT NOT NULL DEFAULT 0,
	notes TEXT,
	location TEXT
) ENGINE=InnoDB;

CREATE TABLE associates (
	mac CHAR(12) NOT NULL PRIMARY KEY,
	group_name VARCHAR(255) NOT NULL,
	FOREIGN KEY (mac) REFERENCES ap(mac) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE groups (
	group_name VARCHAR(255) NOT NULL PRIMARY KEY DEFAULT 'default',
	group_description TEXT
) ENGINE=InnoDB;

CREATE TABLE administrator (
	user_name VARCHAR(255) NOT NULL PRIMARY KEY,
	password VARCHAR(255) NOT NULL,
	real_name VARCHAR(255),
	description TEXT
) ENGINE=InnoDB;

CREATE TABLE heartbeat (
	mac CHAR(12) NOT NULL PRIMARY KEY,
	uptime CHAR(10),
	ap_version VARCHAR(255),
	time_stamp CHAR(10),
	FOREIGN KEY (mac) REFERENCES ap(mac) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE module_uses (
	mac CHAR(12) NOT NULL PRIMARY KEY,
	module_name VARCHAR(255) NOT NULL UNIQUE,
	module_version INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE module_files (
	module_name VARCHAR(255) NOT NULL PRIMARY KEY,
	remote_file VARCHAR(255) NOT NULL,
	local_file VARCHAR(255) NOT NULL,
	FOREIGN KEY (module_name) REFERENCES module_uses(module_name) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE module_commands (
	module_name VARCHAR(255) NOT NULL PRIMARY KEY,
	command VARCHAR(255),
	package_name VARCHAR(255),
	FOREIGN KEY (module_name) REFERENCES module_uses(module_name) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE configuration (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	current_version INT NOT NULL DEFAULT 0,
	run_command VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE contains (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	config_id INT NOT NULL,
	module_name VARCHAR(255) NOT NULL,
	FOREIGN KEY (module_name) REFERENCES module_uses(module_name) ON DELETE CASCADE,
	FOREIGN KEY (config_id) REFERENCES configuration(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE loads (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	config_id INT NOT NULL,
	group_name VARCHAR(255) NOT NULL,
	FOREIGN KEY (config_id) REFERENCES configuration(id) ON DELETE CASCADE,
	FOREIGN KEY (group_name) REFERENCES groups(group_name) ON DELETE CASCADE
) ENGINE=InnoDB;
