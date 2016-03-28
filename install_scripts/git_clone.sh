#####################
# Clone the GIT repos
#####################
SHARED_DIR=$1
WORKING_DIR=$SHARED_DIR/repos
echo "Cloning the repository content fixtures from GitHub."
cd $WORKING_DIR
git clone https://github.com/barmintor/usna_demo_hydra9.git
cd usna_demo_hydra9
git checkout cul-minicamp
echo "Cloning the Fedora 3 project"
cd $WORKING_DIR
git clone https://github.com/barmintor/usna_demo_hydra8.git
cd usna_demo_hydra8
git checkout cul-minicamp
bundle install
bundle exec rake usna:load reload=true
echo "Cloning the workshop migration project from GitHub."
cd $WORKING_DIR
git clone https://github.com/barmintor/cul-minicamp.git
cd cul-minicamp
bundle install
cd $WORKING_DIR
