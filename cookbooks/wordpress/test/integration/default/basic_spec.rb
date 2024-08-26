require 'chefspec'

describe 'wordpress::default' do
  platform 'ubuntu', '20.04'

  it 'converges successfully' do
    expect(chef_run).to_not raise_error
  end

  it 'installs apache2' do
    expect(chef_run).to install_package('apache2')
  end

  it 'starts and enables apache2 service' do
    expect(chef_run).to start_service('apache2')
    expect(chef_run).to enable_service('apache2')
  end

  it 'creates a configuration file with the correct content' do
    expect(chef_run).to create_template('/etc/apache2/sites-available/wordpress.conf')
      .with(
        source: 'wordpress.conf.erb',
        variables: { server_name: 'example.com' }
      )
  end

  it 'creates a log directory' do
    expect(chef_run).to create_directory('/var/log/wordpress')
  end
end
