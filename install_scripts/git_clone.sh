#####################
# Clone the GIT repos
#####################
WORKING_DIR=`pwd`
echo "Cloning the fedora 3 content project from GitHub."
git clone https://github.com/barmintor/usna_demo_hydra8.git
cd usna_demo_hydra8
bundle install
rake usna:load reload=true
cd $WORKING_DIR
echo "Cloning the workshop migration project from GitHub."
git clone https://github.com/barmintor/fedora-migrate-workshop.git
cd fedora-migrate-workshop
bundle install
cd $WORKING_DIR
