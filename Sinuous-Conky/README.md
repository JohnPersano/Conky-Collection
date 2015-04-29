Sinuous Conky
================
Sinuous Conky is a clean, minimalistic Conky configuration that will compliment any Linux system. Each semi-circle provides a visual representation of CPU usage, RAM usage, CPU temperature, and battery percentage. 

This work is derived from the work of 'clanlordus89' whose work may be found at [http://clanlordus89.deviantart.com/art/Circles-of-imagination-192930609](http://clanlordus89.deviantart.com/art/Circles-of-imagination-192930609) <br>

This work is modelled after the work of 'londonali1010' whose work may be found at [http://londonali1010.deviantart.com/art/Conky-Widgets-Script-141963883](http://londonali1010.deviantart.com/art/Conky-Widgets-Script-141963883)
    
![Screenshot](https://cdn.rawgit.com/JohnPersano/Conky-Collection/master/Sinuous-Conky/Screenshot.png)
Screenshot taken on a system running Elementary OS Freya. <br>
The wallpaper in the above screenshot can be found [here](http://tarantonio.deviantart.com/art/elementary-blue-wallpaper-pack-328062009).

Automated installation
======================
**If you already have a Conky setup, backup any existing .conkyrc and .lua files before running this script.**

A simple [install script](https://github.com/JohnPersano/Conky-Collection/blob/master/Sinuous-Conky/configure.sh) has been included with this Conky configuration. To use the script, execute the following command in a Terminal:

```
wget -O configure.sh  https://raw.githubusercontent.com/JohnPersano/Conky-Collection/master/Sinuous-Conky/configure.sh && chmod +x configure.sh &&./configure.sh
```
**Note: You should never run a script like this without inspecting the script's code for malicious content.**

The above commads will download and run a script that will install Sinuous Conky and satisfy every dependency necessary to run it. Once the script has sucessfully completed and Sinuous Conky is up and running, feel free to remove the installation script by executing the following command in a Terminal:

```
rm ./configure.sh
```


Manual installation
===================

Download the .conkyrc and .lua.lua files by executing the following commands in a terminal:

```
wget -O .conkyrc https://raw.githubusercontent.com/JohnPersano/Conky-Collection/master/Sinuous-Conky/.conkyrc
wget -O .lua.lua https://raw.githubusercontent.com/JohnPersano/Conky-Collection/master/Sinuous-Conky/.lua.lua
```

####Dependencies
Sinuous Conky depends on the 'conky' and 'lm-sensors' packages, you can install these packages by executing the following commands in a Terminal.
```
sudo apt-get install conky
sudo apt-get install lm-sensors
```

Sinuous Conky also depends on the Roboto font which can be installed by executing the following commands in a Terminal:

```
mkdir .fonts/Roboto/ -p 
wget -qO- -O ~/.fonts/Roboto/tmp.zip http://www.fontsquirrel.com/fonts/download/roboto 
unzip ~/.fonts/Roboto/tmp.zip -d ~/.fonts/Roboto/
rm ~/.fonts/Roboto/tmp.zip 
fc-cache -fv
```

License
=======

    Copyright 2015 John Persano

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
