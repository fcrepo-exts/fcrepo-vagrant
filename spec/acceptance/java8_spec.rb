require 'spec_helper_acceptance'

describe 'Java 8 installation' do

  describe package('oracle-java8-installer') do
    it { should be_installed }
  end

  describe package('oracle-java8-set-default') do
    it { should be_installed }
  end
end
