require 'spec_helper_acceptance'

describe 'Fuseki installation' do

  describe file('/etc/fuseki') do
    it { should be_directory }
    it { should be_owned_by 'tomcat7' }
    it { should be_grouped_into 'tomcat7' }
  end

  describe file('/var/lib/tomcat7/webapps') do
    it { should be_directory }
    it { should be_owned_by 'tomcat7' }
    it { should be_grouped_into 'tomcat7' }
  end

  describe service('tomcat7') do
    it { should be_running }
  end
end
