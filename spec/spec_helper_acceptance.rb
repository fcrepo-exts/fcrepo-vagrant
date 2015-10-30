require 'beaker-rspec'
# require 'pry'

hosts.each do |host|

  # Provision the environment using the BASH scripts
  bash_root = File.expand_path(File.join(File.dirname(__FILE__), '../install_scripts'))

#  on host, File.read("#{bash_root}/bootstrap.sh")
#  on host, File.read("#{bash_root}/java.sh")
#  on host, File.read("#{bash_root}/tomcat7.sh")
#  on host, File.read("#{bash_root}/solr.sh")
#  on host, File.read("#{bash_root}/fuseki.sh")
#  on host, File.read("#{bash_root}/karaf.sh")

end

RSpec.configure do |c|

  c.formatter = :documentation
end
