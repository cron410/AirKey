<?php
	class Configure extends CI_Controller
	{
		function index()
		{
			$this->load->helper('directory');

			$this->load->view('header_view');
			$this->load->model('aplist_model');

			$data['modules'] = directory_map('./application/controllers/modules/', TRUE);

			$data['pending'] = $this->aplist_model->showPendingAP();
			$data['active'] = $this->aplist_model->showActiveAP();
			$this->load->view('configure_view', $data);
			$this->load->view('footer_view');
		}

		function search()
		{
			return true;
		}

		function configAP($mac)
		{
			$this->load->model('aplist_model');

			if ($_POST) //make form submitted
			{
				$name = $this->security->xss_clean($this->input->post('APname'));
				$name = str_replace(' ','',$name); //Remove spaces
				$this->aplist_model->changeName($mac, $name);
			}

			$data = $this->aplist_model->showAP($mac);
			$this->load->view('showAP_view', $data);
		}

		function group()
		{
			$this->load->model('aplist_model');

			if ($_POST) //make sure that data has been posted
			{
				$groupName = $this->security->xss_clean($this->input->post('groupName'));

				switch($this->input->post('actionDropDown'))
				{
					case 'add':
					case 'create':
						// Create a new group
						foreach ($this->input->post('mac') as $mac)
						{
							$this->aplist_model->changeGroup($mac, $groupName);
						}
					break;

					case 'delete':
						// Remove AP from Group
						foreach ($this->input->post('mac') as $mac)
						{
							$this->load->model('modules/modules_model');
							$this->modules_model->removeGroup($mac);
						}
						break;
				}
			}
			redirect('configure');
		}
	}
?>