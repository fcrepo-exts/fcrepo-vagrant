require 'spec_helper_acceptance'

describe 'Maven 3 installation' do

  describe package('maven') do
    it { should be_installed }
  end

  describe command('mvn -version') do
    its(:stdout) { should match /Apache Maven 3/ }
  end
end
