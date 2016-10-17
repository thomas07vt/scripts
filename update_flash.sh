#!/usr/bin/env bash

# Static DL Link:
# https://get.adobe.com/flashplayer/download/?installer=FP_11.2_for_other_Linux_64-bit_(.tar.gz)_-_NPAPI&standalone=1
#
#Installing using the plugin tar.gz:
#  o Unpack the plugin tar.gz and copy the files to the appropriate location.
#  o Save the plugin tar.gz locally and note the location the file was saved to.
#  o Launch terminal and change directories to the location the file was saved to.
#  o Unpack the tar.gz file.  Once unpacked you will see the following:
#    + libflashplayer.so
#    + /usr
#  o Identify the location of the browser plugins directory, based on your Linux distribution and Firefox version
#  o Copy libflashplayer.so to the appropriate browser plugins directory.  At the prompt type:
#    + cp libflashlayer.so <BrowserPluginsLocation>
#  o Copy the Flash Player Local Settings configurations files to the /usr directory.  At the prompt type:
#    + sudo cp -r usr/* /usr

# Example download link
# https://fpdownload.adobe.com/get/flashplayer/pdc/11.2.202.632/install_flash_player_11_linux.x86_64.tar.gz

downloadFlash(){
  # Find Download Link from static URL
  dlink=$(curl -v -L --silent "https://get.adobe.com/flashplayer/download/?installer=FP_11.2_for_other_Linux_64-bit_(.tar.gz)_-_NPAPI&sType=2723&standalone=1" 2>&1 \
    | grep "fpdownload.adobe.com" \
    | sed $'s/^.*location.href = \'//' | sed $'s/\';".*//'
  )
  echo "Download Link found: $dlink"

  # Download to /tmp
  curl -o /tmp/flash.tar.gz $dlink
}

extractFlashTar() {
  mkdir -p /tmp/flash
  tar -xzf /tmp/flash.tar.gz -C /tmp/flash
}


replaceSOFiles() {
  echo "Replacing old libflashplayer.so files with the newest one."
  sudo find / -name libflashplayer.so -type f -exec cp /tmp/flash/libflashplayer.so {} \;
}

copyUSRFolder() {
  echo "Copying flash usr files"
  # This is prolly dangerous...
  sudo cp -r /tmp/flash/usr/* /usr
}

removeFlashFiles() {
  echo "Removing tmp flash files."
  rm -rf /tmp/flash
  rm /tmp/flash.tar.gz
}


echo "Updating Flash..."

downloadFlash
extractFlashTar
replaceSOFiles
copyUSRFolder
removeFlashFiles

echo "Done."


