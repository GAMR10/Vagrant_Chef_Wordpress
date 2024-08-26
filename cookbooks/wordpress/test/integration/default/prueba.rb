# Verificar si estamos en un sistema Ubuntu .
if os.family == 'debian'
    describe package('apache2') do
      it { should be_installed }
    end
  
    describe service('apache2') do
      it { should be_enabled }
      it { should be_running }
    end
  
    describe file('/etc/apache2/apache2.conf') do
      its('content') { should match /KeepAlive On/ }
    end
  
    describe file('/var/log/apache2/access.log') do
      it { should exist }
    end
  elsif os.family == 'redhat'
    describe package('httpd') do
      it { should be_installed }
    end
  
    describe service('httpd') do
      it { should be_enabled }
      it { should be_running }
    end
  
    describe file('/etc/httpd/conf/httpd.conf') do
      its('content') { should match /KeepAlive On/ }
    end
  
    describe file('/var/log/httpd/access_log') do
      it { should exist }
    end
  end
  