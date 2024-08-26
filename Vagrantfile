Vagrant.configure("2") do |config|
    config.env.enable  # Habilitamos vagrant-env(.env)

    if ENV['TESTS'] == 'true'
        config.vm.define "test" do |testing|
            testing.vm.box = ENV["BOX_NAME"] || "ubuntu/focal64"
            testing.vm.boot_timeout = 600  # Aumenta el tiempo de espera a 300 segundos (5 minutos)
            
            testing.vm.provision "shell", inline: <<-SHELL
                sleep 10
                # ... otros comandos
            SHELL
        end
    else
        config.vm.define "database" do |db|
            db.vm.box = ENV["BOX_NAME"] || "ubuntu/focal64"
            db.vm.hostname = "db.epnewman.edu.pe"
            db.vm.network "private_network", ip: ENV["DB_IP"]
            db.vm.boot_timeout = 300  # Aumenta el tiempo de espera a 300 segundos (5 minutos)

            db.vm.provision "shell", inline: <<-SHELL
                sleep 10
                # ... otros comandos
            SHELL
            
            db.vm.provision "chef_solo" do |chef|
                chef.install = "true"
                chef.arguments = "--chef-license accept"
                chef.add_recipe "database"
                chef.json = {
                    "config" => {
                        "db_ip" => "#{ENV["DB_IP"]}",
                        "wp_ip" => "#{ENV["WP_IP"]}",
                        "db_user" => "#{ENV["DB_USER"]}",
                        "db_pswd" => "#{ENV["DB_PSWD"]}"
                    }
                }
            end
        end

        config.vm.define "wordpress" do |sitio|
            sitio.vm.box = ENV["BOX_NAME"] || "ubuntu/focal64"
            sitio.vm.hostname = "wordpress.epnewman.edu.pe"
            sitio.vm.network "private_network", ip: ENV["WP_IP"]
            sitio.vm.boot_timeout = 300  # Aumenta el tiempo de espera a 300 segundos (5 minutos)

            sitio.vm.provision "shell", inline: <<-SHELL
                sleep 10
                # ... otros comandos
            SHELL
            
            sitio.vm.provision "chef_solo" do |chef|
                chef.install = "true"
                chef.arguments = "--chef-license accept"
                chef.add_recipe "wordpress"
                chef.json = {
                    "config" => {
                        "db_ip" => "#{ENV["DB_IP"]}",
                        "db_user" => "#{ENV["DB_USER"]}",
                        "db_pswd" => "#{ENV["DB_PSWD"]}"
                    }
                }
            end
        end

        # Otras configuraciones...
    end
end
