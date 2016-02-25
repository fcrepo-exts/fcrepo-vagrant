require 'spec_helper_acceptance'

describe 'Karaf installation' do

  describe file('/opt/apache-karaf-4.0.1') do
    it { should be_directory }
  end

  describe file('/opt/karaf') do
    it { should be_symlink }
  end

  describe file('/opt/karaf/etc/org.ops4j.pax.url.mvn.cfg') do
    its(:content) { should match /\/home\/vagrant\/\.m2\/repository/ }
  end

  describe service('karaf-service') do
    it { should be_running }
  end
end
