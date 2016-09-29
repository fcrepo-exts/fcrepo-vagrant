#####################
# Clone the GIT repos
#####################
SHARED_DIR=$1
WORKING_DIR=$SHARED_DIR/repos
echo "Cloning the workshop migration project from GitHub."
cd $WORKING_DIR
git clone https://github.com/barmintor/hyconn2016.git
cd hyconn2016
bundle install
cd $WORKING_DIR
