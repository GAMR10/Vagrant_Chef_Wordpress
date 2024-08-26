execute "get wordpress" do
    command "curl -o /tmp/wordpress.zip https://wordpress.org/latest.zip"
    action :run
    not_if { ::File.exist?('/tmp/wordpress.zip') }
end

execute "extract_wordpress" do
    command "unzip -q /tmp/wordpress.zip -d /opt/"
    action :run
    notifies :run, 'execute[set_wordpress_permissions]', :immediately
    not_if { ::File.exist?('/opt/wordpress') }
end

execute "set_wordpress_permissions" do
    command "chown -R www-data:www-data /opt/wordpress"
    action :nothing
end

template '/opt/wordpress/wp-config.php' do
    source 'wp-config.php.erb'
    owner 'www-data'
    group 'www-data'
    mode '0644'
    not_if { ::File.exist?('/opt/wordpress/wp-config.php') }
end

template '/etc/apache2/sites-available/wordpress.conf' do
    source 'wordpress.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :run, 'execute[enable_wordpress_site]', :immediately
end

execute "disable_default_site" do
    command "a2dissite 000-default.conf"
    action :run
    notifies :reload, 'service[apache2]', :immediately
    only_if { ::File.exist?('/etc/apache2/sites-enabled/000-default.conf') }
end

execute "enable_wordpress_site" do
    command "a2ensite wordpress.conf"
    action :nothing
    notifies :reload, 'service[apache2]', :immediately
end

service "apache2" do
    action [:enable, :start]
end
