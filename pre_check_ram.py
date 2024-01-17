class PrereqCheckRAM(MapRPrereqCheck):

    def __init__(self, ansible_module):
        super(PrereqCheckRAM, self).__init__(ansible_module, "RAM", "check_ram")

        self.machine_ram = self.ansible_module.params['ram']
        self.core_ver = MaprVersion(ansible_module.params['core_ver'])
        # Getting values from group_vars/all, extracting only 'ram'
        self.prereq_values = ansible_module.params['prereq_values']['ram']
        self.MIN_RAM = self.prereq_values['MIN_RAM']
        self.WARN_RAM = self.prereq_values['WARN_RAM']
        # Azure has some machines that have a strange limit like 14GB
        self.MIN_RAM_CLOUD = self.prereq_values['MIN_RAM_CLOUD']
        self.RAM_CLOUD_WARN = self.prereq_values['WARN_RAM_CLOUD']
        # For version less or eq to 5.2.3 minimal RAM should be 8.0GB.
        self.MIN_RAM_v5 = self.prereq_values['MIN_RAM_v5']

    def process(self):
        ram_in_gb = MapRPrereqCheck.to_gb(self.machine_ram)
        if self.is_cloud:
            min_ram = self.MIN_RAM_CLOUD
            warn_ram = self.RAM_CLOUD_WARN
        else:
            if self.core_ver <= MaprVersion('5.2.3'):
                min_ram = self.MIN_RAM_v5
            else:
                min_ram = self.MIN_RAM
            warn_ram = self.WARN_RAM

        self.value = "{0} GB".format(ram_in_gb)
        self.required = "{0} GB".format(warn_ram)

        if ram_in_gb >= warn_ram:
            self.set_state(MapRPrereqCheck.VALID)
        elif ram_in_gb >= min_ram:
            self.required = "{0} GB. You only have {1} available. Depending on the services " \
                            "you have configured, this node may perform poorly due to lack of memory. " \
                            "Please make sure this node is adequately sized before continuing " \
                            "the install.".format(warn_ram, ram_in_gb)
            self.set_state(MapRPrereqCheck.WARN)
        else:
            self.required = "{0} GB. You only have {1} available. This is less than the absolute minimum " \
                            "amount of memory MapR require for a node of {1} GB. This node is not suitable " \
                            "to run our software. Please add more memory before retrying " \
                            "the install.".format(warn_ram, ram_in_gb)
            self.set_state(MapRPrereqCheck.ERROR)

        self.set_state(MapRPrereqCheck.VALID)
