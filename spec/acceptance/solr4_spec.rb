require 'spec_helper_acceptance'

describe 'Apache Solr installation' do

  describe file('/var/lib/tomcat7/solr') do
    it { should be_directory }
    it { should be_owned_by 'tomcat7' }
    it { should be_grouped_into 'tomcat7' }
  end

  describe file('/var/lib/tomcat7/solr/collection1/conf/schema.xml') do
    it { should be_file }
    it { should be_owned_by 'tomcat7' }
    it { should be_grouped_into 'tomcat7' }
  end
  
  describe service('tomcat7') do
    it { should be_running }
  end
end
