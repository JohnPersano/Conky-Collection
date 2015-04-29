#!/bin/bash
#
# Copyright 2015 John Persano
#
# Licensed under the Apache License, Version 2.0 (the "License");
#     you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# These are the packages that are required for this Conky configuration
declare -a packages=("conky-all" "lm-sensors");

## Iterate through each package and check if it is installed
for i in "${packages[@]}"; do
    if [ $(dpkg-query -W -f='${Status}' $i 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        echo "$i is not installed, would you like to install it now? (Y/N)";
        read response
        if [ "$response" == "y" ] || [ "$response" == "Y" ]; then
            sudo apt-get install "$i";
        else
            echo "Skipping the installation of $i...";
            echo "Please note that this Conky configuration will not work without the $i package.";
        fi

    else
        echo "The $i package has already been installed.";
    fi
done

# Check if the Roboto font is installed
FONT_INSTALLED=$(fc-list | grep -i "roboto");
if [ -z "$FONT_INSTALLED" ]; then
    echo "The Roboto font is not currently installed, would you like to install it now? (Y/N)";
    read response
    if [ "$response" == "y" ] || [ "$response" == "Y" ]; then
        echo "Installing the Roboto font to the ~/.fonts directory...";
        mkdir .fonts/Roboto/ -p && wget -qO- -O ~/.fonts/Roboto/tmp.zip http://www.fontsquirrel.com/fonts/download/roboto && 
        unzip ~/.fonts/Roboto/tmp.zip -d ~/.fonts/Roboto/ > /dev/null && rm ~/.fonts/Roboto/tmp.zip 
        fc-cache -fv > /dev/null
        FONT_INSTALLED=$(fc-list | grep -i "roboto");
        if [ -n "$FONT_INSTALLED" ]; then
            echo "The Roboto font was sucessfully installed!";
        else
            echo "Something went wrong while trying to install the Roboto font.";
            echo "Please download the font from http://www.fontsquirrel.com/fonts/download/roboto, unzip it, and move the folder to the ~/.fonts directory.";
            echo "After you have done that, refresh the font cache by executing the 'fc-cache -fv' command.";
        fi
    else
        echo "Skipping the installation of the Roboto font...";
        echo "Please note that this Conky configuration will not work without the Roboto font.";
    fi
else
    echo "The Roboto font has already been installed.";
fi

# Download .conkyrc and lua.lua from Github
wget -O .conkyrc https://raw.githubusercontent.com/JohnPersano/Conky-Collection/master/Sinuous-Conky/.conkyrc
wget -O .lua.lua https://raw.githubusercontent.com/JohnPersano/Conky-Collection/master/Sinuous-Conky/.lua.lua

#Try to run Conky
FONT_INSTALLED=$(fc-list | grep -i "roboto");
if [ $(dpkg-query -W -f='${Status}' ${packages[1]} 2>/dev/null | grep -c "ok installed") -eq 1 ] && 
   [ $(dpkg-query -W -f='${Status}' ${packages[2]} 2>/dev/null | grep -c "ok installed") -eq 1 ] &&
   [ -n "$FONT_INSTALLED" ]; then
    echo "All dependencies have been satisfied, attempting to start Conky...";
    conky &
    else
        echo "Conky cannot start due the following unmet dependencies...";
        for i in "${packages[@]}"; do
            if [ $(dpkg-query -W -f='${Status}' $i 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
                echo "$i";
            fi
        done
        echo "Please try installing these dependencies using 'apt-get install <dependency>' or rerun this script.";
fi






