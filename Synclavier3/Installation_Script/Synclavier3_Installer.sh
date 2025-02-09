#!/bin/sh
#==============================================================================#
# 
#                        ███╗   ██╗███████╗██╗    ██╗                     
#                        ████╗  ██║██╔════╝██║    ██║                     
#                        ██╔██╗ ██║█████╗  ██║ █╗ ██║                     
#                        ██║╚██╗██║██╔══╝  ██║███╗██║                     
#                        ██║ ╚████║███████╗╚███╔███╔╝                     
#                        ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝                      
#                                                                 
#        ███████╗███╗   ██╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗     
#        ██╔════╝████╗  ██║██╔════╝ ██║     ██╔══██╗████╗  ██║██╔══██╗    
#        █████╗  ██╔██╗ ██║██║  ███╗██║     ███████║██╔██╗ ██║██║  ██║    
#        ██╔══╝  ██║╚██╗██║██║   ██║██║     ██╔══██║██║╚██╗██║██║  ██║    
#        ███████╗██║ ╚████║╚██████╔╝███████╗██║  ██║██║ ╚████║██████╔╝    
#        ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝     
#                                                                 
#                ██████╗ ██╗ ██████╗ ██╗████████╗ █████╗ ██╗              
#                ██╔══██╗██║██╔════╝ ██║╚══██╔══╝██╔══██╗██║              
#                ██║  ██║██║██║  ███╗██║   ██║   ███████║██║              
#                ██║  ██║██║██║   ██║██║   ██║   ██╔══██║██║              
#                ██████╔╝██║╚██████╔╝██║   ██║   ██║  ██║███████╗         
#                ╚═════╝ ╚═╝ ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝         
#                                                                                                                                                                                                                   
#==============================================================================#
#
#                      N.E.D. -- NEW ENGLAND DIGITAL
# 
# File Name   : Synclavier3_Installer.sh
#
# Description : Script used to install the Synclavier³ Kernel Extension and the
#               MIDI Plug-in on MAC OS/X version with issue while opening the
#               official .pkg file. 
#
# Date        : February 2025
#
# Creator     : Laurent Lemaire
#
# Contact     : laurent@new-england-digital.com
#
#==============================================================================#

echo
echo "Running Synclavier3_Installer.sh (version 1.0)"
echo "--"

#------------------------------------------------------------------------------#
echo "Step 1 : Aquiring administrator privileges."

    prompt=$(sudo -ln 2>&1)
    if [ $? -eq 0 ]; then
      echo "OK : Administrator privileges granted."
    elif echo $prompt | grep -q '^sudo:'; then
      # echo "--"                               # DEBUG TRACES ...
      # echo "DEBUG : sudo result = " $prompt   # DEBUG TRACES ...
      # echo "--"                               # DEBUG TRACES ...
      echo "ERROR: Please use the sudo command to launch this script with" \
           "administrator privileges."
      exit 1;
    else
      echo "ERROR : sudo command not found ..."
      exit 2;
    fi
    echo "--"

#------------------------------------------------------------------------------#
echo "Step 2 : Checking the Synclavier³ installation DMG is opened and mounted."

    dmgfile=$(ls '/Volumes/Synclavier³ Disk Image' 2>&1)
    if [ $? -eq 0 ]; then
      echo "OK : /Volumes/Synclavier³ Disk Image is mounted."
    else
      # echo "--"                              # DEBUG TRACES ...
      # echo "DEBUG : ls result = " $dmgfile   # DEBUG TRACES ...
      # echo "--"                              # DEBUG TRACES ...
      echo "ERROR : Please open a Synclavier³ DMG file"
      exit 1;
    fi
    echo "--"

#------------------------------------------------------------------------------#
echo "Step 3 : Checking the MAC OS/X Version running."
echo "         --> Only versions 10.9 to 10.12 are supported."

    osxversion=$(sw_vers -productVersion 2>&1)
    if [[ "$osxversion" == "10.9"* ]]; then
        echo "OK : Mac OS/X 10.9 (Mavericks) is supported by this script."
        installer_pkg_filename="Synclavier_C2_B3_10-9_-_10-10_Installer.pkg"
   elif [[ "$osxversion" == "10.10"* ]]; then
        echo "OK : Mac OS/X 10.10 (Yosemite) is supported by this script."
        installer_pkg_filename="Synclavier_C2_B3_10-9_-_10-10_Installer.pkg"
   elif [[ "$osxversion" == "10.11"* ]]; then
        echo "OK : Mac OS/X 10.11 (El Capitan) is supported by this script."
        installer_pkg_filename="Synclavier_C2_B3_10-11_-_10-12_Installer.pkg"
   elif [[ "$osxversion" == "10.12"* ]]; then
        echo "OK : Mac OS/X 10.12 (Sierra) is supported by this script."
        installer_pkg_filename="Synclavier_C2_B3_10-11_-_10-12_Installer.pkg"
    else
      echo "--"                                      # DEBUG TRACES ...
      echo "DEBUG : sw_vers result = " $osxversion   # DEBUG TRACES ...
      echo "--"                                      # DEBUG TRACES ...
      echo "ERROR : Mac OS/X " $osxversion " is not supported by this script."
      exit 1;
    fi
    echo "--"

#------------------------------------------------------------------------------#
echo "Step 4 : Expanding the Synclavier³ Installation Package file into /tmp."

    timestamp=$(date "+%m%d%H%M%Y.%S")
    targetdir="/tmp/Synclavier3_Installer_"$timestamp
    sync3instpkg="/Volumes/Synclavier³ Disk Image/Synclavier³ Installer.pkg"
    pkgtmpfile=$(pkgutil --expand "$sync3instpkg" "$targetdir" 2>&1)
    if [ $? -eq 0 ]; then
      echo "OK : Synclavier³ Installer Package file has been expanded."
    else
      # echo "--"                              # DEBUG TRACES ...
      # echo "DEBUG : timestamp result = " $timestamp   # DEBUG TRACES ...
      # echo "DEBUG : pkgutil   result = " $pkgtmpfile   # DEBUG TRACES ...
      # echo "--"                              # DEBUG TRACES ...
      echo "ERROR : Please open a Synclavier³ DMG file"
      exit 1;
    fi
    echo "--"

#------------------------------------------------------------------------------#
echo "Step 5 : Removing the old Kernel Extension and MIDI Pluggin if present."

    preinstscript=$targetdir/$installer_pkg_filename/Scripts/preinstall
    preinstres=$(sudo $preinstscript 2>&1)
    if [ $? -eq 0 ]; then
      echo "OK : Preinst script has been executed correcly."
    else
      echo "--"                                          # DEBUG TRACES ...
      echo "DEBUG : preinstall path   = " $preinstscript # DEBUG TRACES ...
      echo "DEBUG : preinstall result = " $preinstres    # DEBUG TRACES ...
      echo "--"                                          # DEBUG TRACES ...
      echo "ERROR : Preinstallation FAILED ..."
      exit 1;
    fi
    echo "--"

#------------------------------------------------------------------------------#
echo "Step 6 : Creating the new Payload target directory into /tmp."

    payloadnewdir=/tmp/Payload_$timestamp
    mkdirres=$(mkdir $payloadnewdir 2>&1)
    if [ $? -eq 0 ]; then
      echo "OK : New Payload directory has been created with success."
    else
      echo "--"                                              # DEBUG TRACES ...
      echo "DEBUG : payload new directory = " $payloadnewdir # DEBUG TRACES ...
      echo "DEBUG : mkdir result          = " $mkdirres      # DEBUG TRACES ...
      echo "--"                                              # DEBUG TRACES ...
      echo "ERROR :  New Payload directory creation FAILED ..."
      exit 1;
    fi
    echo "--"


#------------------------------------------------------------------------------#
echo "Step 7 : Expanding the Payload archive into /tmp."

    payloadfile=$targetdir/$installer_pkg_filename/Payload
    untarres=$(sudo tar xvf $payloadfile -C $payloadnewdir 2>&1)
    if [ $? -eq 0 ]; then
      echo "OK : Payload has been expanded correcly."
    else
      echo "--"                                         # DEBUG TRACES ...
      echo "DEBUG : payloadfile path = " $payloadfile   # DEBUG TRACES ...
      echo "DEBUG : tar result       = " $untarres      # DEBUG TRACES ...
      echo "--"                                         # DEBUG TRACES ...
      echo "ERROR : Payload expand into /tmp FAILED ..."
      exit 1;
    fi
    echo "--"


#------------------------------------------------------------------------------#
echo "Step 8 : Installing the MIDI Icon tiff file."

    miditiffdir="Library/Audio/MIDI Devices/Generic/Images"
    miditifffile="SynclavierDigitalAudioMIDIIcon.tiff"
    cptiffres=$(sudo cp "$payloadnewdir/""$miditiffdir/""$miditifffile" \
                        "/$miditiffdir" 2>&1)
    if [ $? -eq 0 ]; then
      echo "OK : MIDI Icon File has been copied with success."
    else
      echo "--"                                          # DEBUG TRACES ...
      echo "DEBUG : MIDI tiff dirname  = " $miditiffdir  # DEBUG TRACES ...
      echo "DEBUG : MIDI tiff filename = " $miditifffile # DEBUG TRACES ...
      echo "DEBUG : copy result        = " $cptiffres    # DEBUG TRACES ...
      echo "--"                                          # DEBUG TRACES ...
      echo "ERROR : MIDI Icon File copy FAILED ..."
      exit 1;
    fi
    echo "--"

#------------------------------------------------------------------------------#
echo "Step 9 : Installing the MIDI Plugin file."

    midiplugindir="Library/Audio/MIDI Drivers"
    midipluginfile="SynclavierDigitalMIDIDriver.plugin"
    cppluginres=$(sudo cp -R "$payloadnewdir/""$midiplugindir/""$midipluginfile" \
                             "/$midiplugindir" 2>&1)
    if [ $? -eq 0 ]; then
      echo "OK : MIDI Plugin File has been copied with success."
    else
      echo "--"                                              # DEBUG TRACES ...
      echo "DEBUG : MIDI Plugin dirname  = " $midiplugindir  # DEBUG TRACES ...
      echo "DEBUG : MIDI Plugin filename = " $midipluginfile # DEBUG TRACES ...
      echo "DEBUG : copy result          = " $cppluginres    # DEBUG TRACES ...
      echo "--"                                              # DEBUG TRACES ...
      echo "ERROR : MIDI Plug File copy FAILED ..."
      exit 1;
    fi
    echo "--"

#------------------------------------------------------------------------------#
echo "Step 10 : Installing the PCI Card Kernel Extension file."

    kernelextdir="Library/Extensions"
    kernelextfile="SynclavierDigitalPCI.kext"
    cpkextres=$(sudo cp -R "$payloadnewdir/""$kernelextdir/""$kernelextfile" \
                           "/$kernelextdir" 2>&1)
    if [ $? -eq 0 ]; then
      echo "OK : MIDI Icon File has been copied with success."
    else
      echo "--"                                             # DEBUG TRACES ...
      echo "DEBUG : Kernel Ext. dirname  = " $kernelextdir  # DEBUG TRACES ...
      echo "DEBUG : Kernel Ext. filename = " $kernelextfile # DEBUG TRACES ...
      echo "DEBUG : copy result          = " $cpkextres     # DEBUG TRACES ...
      echo "--"                                             # DEBUG TRACES ...
      echo "ERROR : MIDI Icon File copy FAILED ..."
      exit 1;
    fi
    echo "--"

#------------------------------------------------------------------------------#
echo "Step 12 : Removing the Payload archive from /tmp."

    removeplres=$(sudo rm -rf $payloadnewdir 2>&1)
    if [ $? -eq 0 ]; then
      echo "OK : Payload has been removed with success from /tmp."
    else
      echo "--"                                           # DEBUG TRACES ...
      echo "DEBUG : payloadnewdir path = " $payloadnewdir # DEBUG TRACES ...
      echo "DEBUG : rm result          = " $removeplres   # DEBUG TRACES ...
      echo "--"                                           # DEBUG TRACES ...
      echo "ERROR : Payload archive removal from /tmp FAILED ..."
      exit 1;
    fi
    echo "--"

#------------------------------------------------------------------------------#
echo "Step 13 : Removing the Synclavier³ Installation Package file from /tmp."

    rmpkgtmpres=$( sudo rm -rf $targetdir 2>&1)
    if [ $? -eq 0 ]; then
      echo "OK : Synclavier³ Installer Package file has been removed."
    else
      echo "--"                                         # DEBUG TRACES ...
      echo "DEBUG : rmpkgtmpres path = " $rmpkgtmpres   # DEBUG TRACES ...
      echo "DEBUG : rm   result      = " $rmpkgtmpres   # DEBUG TRACES ...
      echo "--"                                         # DEBUG TRACES ...
      echo "ERROR : Failed to remove the Synclavier³ Installation Package file"
      exit 1;
    fi
    echo "--"

#------------------------------------------------------------------------------#
echo "-- INSTALLATION SUCCESS --"
echo
echo "You can copy (drag) the Synclavier3.app into your Applications directory"
echo