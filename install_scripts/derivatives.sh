##################################
# Hydra Derivatives Dependencies #
##################################

echo "Installing ImageMagick."
apt-get -y install imagemagick

echo "Installing FITS."
SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

if [ ! -d "/usr/local/fits" ]; then
  mkdir /usr/local/fits
fi
FITS_DL="http://projects.iq.harvard.edu/files/fits/files"
FITS_VERSION="0.6.2"
if [ ! -f "$DOWNLOAD_DIR/fits-$FITS_VERSION.zip" ]; then
  curl -L -s -o "$DOWNLOAD_DIR/fits-$FITS_VERSION.zip" "$FITS_DL/fits-$FITS_VERSION.zip"
fi

unzip "$DOWNLOAD_DIR/fits-$FITS_VERSION.zip" -d /usr/local/fits
chmod +x /usr/local/fits/fits-0.6.2/fits.sh
chown -R vagrant:vagrant /usr/local/fits
