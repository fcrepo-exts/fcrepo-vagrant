require 'spec_helper_acceptance'

describe 'Apache Tomcat installation' do

#  check_is_installed is not implemented in Specinfra::Command::Ubuntu::Base::Service
  describe package('tomcat7') do
    it { should be_installed }
  end

  describe package('tomcat7-admin') do
    it { should be_installed }
  end

  describe file('/etc/tomcat7/tomcat-users.xml') do
    its(:content) { should match /role rolename="fedoraAdmin"/ }
  end

  describe file('/etc/default/tomcat7') do
    its(:content) { should match /\/usr\/lib\/jvm\/java-8-oracle/ }
  end

end
