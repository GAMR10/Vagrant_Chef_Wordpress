require_relative '../../spec_helper'

describe 'wordpress::default' do
  it 'runs successfully' do
    expect(true).to be true
  end

  context 'When all attributes are default, on an Ubuntu 20.04' do
    it 'installs the apache2 package' do
      expect(chef_run).to install_package('apache2')
    end

    it 'starts and enables the apache2 service' do
      expect(chef_run).to start_service('apache2')
      expect(chef_run).to enable_service('apache2')
    end

    # Nueva prueba: Verificar la instalación del paquete curl
    it 'installs the curl package' do
      expect(chef_run).to install_package('curl')
    end

    # Nueva prueba: Verificar la instalación del paquete php
    it 'installs the php package' do
      expect(chef_run).to install_package('php')
    end
  end
end
