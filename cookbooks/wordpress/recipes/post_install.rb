# # Instalar WP CLI
# remote_file '/tmp/wp' do
#   source 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
#   owner 'root'
#   group 'root'
#   mode '0755'
#   action :create
# end

# # Mover WP CLI a /bin
# execute 'Move WP CLI' do
#   command 'mv /tmp/wp /bin/wp'
#   not_if { ::File.exist?('/bin/wp') }
# end

# # Hacer WP CLI ejecutable
# file '/bin/wp' do
#   mode '0755'
# end

# # Instalar Wordpress y configurar
# execute 'Finish Wordpress installation' do
#   command 'sudo -u vagrant -i -- wp core install --path=/opt/wordpress/ --url=192.168.56.10 --title="EPNEWMAN - Herramientas de automatización de despliegues" --admin_user=admin --admin_password="Epnewman123" --admin_email=admin@epnewman.edu.pe'
#   not_if 'wp core is-installed', environment: { 'PATH' => '/bin:/usr/bin:/usr/local/bin' }
# end

# Instalar WP CLI
remote_file '/tmp/wp' do
  source 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Mover WP CLI a /bin
execute 'Move WP CLI' do
  command 'mv /tmp/wp /bin/wp'
  not_if { ::File.exist?('/bin/wp') }
end

# Hacer WP CLI ejecutable
file '/bin/wp' do
  mode '0755'
end

# Establecer permisos para wp-content
directory '/opt/wordpress/wp-content' do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  action :create
  recursive true
end

# Establecer permisos para el directorio de idiomas
directory '/opt/wordpress/wp-content/languages' do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  action :create
  recursive true
end

# Instalar WordPress y configurar
execute 'Finish WordPress installation' do
  command <<-EOH
    sudo -u vagrant -i -- wp core install --path=/opt/wordpress/ --url=http://192.168.56.10 \
    --title="BLOG PERSONAL" \
    --admin_user=admin --admin_password="Epnewman123" --admin_email=admin@epnewman.edu.pe \
    --locale=es_ES
  EOH
  not_if 'wp core is-installed', environment: { 'PATH' => '/bin:/usr/bin:/usr/local/bin' }
end

# Configurar biografía del usuario administrador
execute 'Set admin user bio' do
  command 'sudo -u vagrant -i -- wp user meta update admin description "Administrador del sitio" --path=/opt/wordpress/'
end

# Configurar la zona horaria
execute 'Set timezone' do
  command 'sudo -u vagrant -i -- wp option update timezone_string "America/Guayaquil" --path=/opt/wordpress/'
end

# Configurar visibilidad en motores de búsqueda
execute 'Set search engine visibility' do
  command 'sudo -u vagrant -i -- wp option update blog_public "0" --path=/opt/wordpress/'  # 0 para no indexar, 1 para indexar
end

# Configurar título y descripción del sitio
execute 'Set site title and description' do
  command <<-EOH
    sudo -u vagrant -i -- wp option update blogname "BLOG PERSONAL" --path=/opt/wordpress/ && \
    sudo -u vagrant -i -- wp option update blogdescription "Herramientas de automatización de despliegues" --path=/opt/wordpress/
  EOH
end

# Crear un usuario adicional
execute 'Create additional user' do
  command 'sudo -u vagrant -i -- wp user create editor gamr21@outlook.es --role=editor --user_pass="morales98" --path=/opt/wordpress/'
end

# Configurar idioma de WordPress a español
execute 'Set WordPress language to Spanish' do
  command <<-EOH
    sudo -u www-data wp option update blog_charset 'UTF-8' --path=/opt/wordpress/
    sudo -u www-data wp option update WPLANG 'es_ES' --path=/opt/wordpress/
    sudo -u www-data wp core language install es_ES --path=/opt/wordpress/
    sudo -u www-data wp core language activate es_ES --path=/opt/wordpress/
  EOH
  not_if 'wp core language list --path=/opt/wordpress/ | grep es_ES', environment: { 'PATH' => '/usr/local/bin:/usr/bin:/bin' }
end



