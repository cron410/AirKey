<?php
	class Main_config extends CI_Controller
	{
		var $mac;
		var $key;

		function index()
		{
			$data['error_msg'] = "Registration Error";
			$this->load->view('error_view', $data);
		}

		function auth($mac = '', $key = '', $command = '')
		{
			if ($mac && $key)
			{
				$this->load->library('Validate');
				$this->load->helper('file');

				$validUser = $this->validate->validateUser($mac, $key);
					if($validUser)
					{
						// Valid User found make the config file
						$this->load->model('config_model');
						// If the command was not blank then remove it
						//TODO Fix the removeing command
#						if ($command == 'removeCommand')
#						{
#							$this->config_model->removeCommand($mac);
#							return true;
#						}

						// Get the data to build the configuration file
						$data['config'] = $this->config_model->getMainConfig($mac);

						//$this->load->view('mainConfig_view', $data);

						$encrypt = $this->load->view('mainConfig_view', $data, TRUE);
						$password = $this->config->item('networkPassword'); // Get password from config file

						$path = "./static/tmp/$mac";
						if (write_file($path, $encrypt))
						{
							// encrypt the file and delete the unencrypted version
							system("./static/scripts/encode.sh $password $path");
							// DELETE the file
							unlink($path);
						}
						else
						{
							// File can't be written
							$data['error_msg'] = "File can not be written";
							$this->load->view('error_view', $data);
						}
					}
					else
					{
						// Not a valid MAC or key
						$data['error_msg'] = "Invalid MAC or Key";
						$this->load->view('error_view', $data);
					}
			}
			else
				$this->load->view('error_view', "MAC or Key Missing"); // MAC or Key not passed
		}
	}
?>
