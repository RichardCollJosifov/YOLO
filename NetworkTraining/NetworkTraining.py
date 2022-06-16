# This cell imports the drive library and mounts your Google Drive as a VM local drive
from google.colab import drive
drive.mount('/content/gdrive')

!sudo apt-get install tree
!tree /content/gdrive/My\ Drive/darknet/

# This cell can be commented once you checked the current CUDA version
# CUDA: Let's check that Nvidia CUDA is already pre-installed and which version is it 
# !/usr/local/cuda/bin/nvcc --version

# We're unzipping the cuDNN files from your Drive folder directly to the VM CUDA folders
!tar -xzvf gdrive/My\ Drive/darknet/cuDNN/cudnn-11.2-linux-x64-v8.1.1.33.jigsawpuzzle8 -C /usr/local/
!chmod a+r /usr/local/cuda/include/cudnn.h
# Now we check the version we already installed. Can comment this line on future runs
# !cat /usr/local/cuda/include/cudnn.h | grep CUDNN_MAJOR -A 2

# Leave this code uncommented on the very first run of your notebook or if you ever need to recompile darknet again.
# Comment this code on the future runs.
#%rm -r darknet
#!git clone https://github.com/pjreddie/darknet
#%cd darknet/
#!git clone https://github.com/AlexeyAB/darknet/
#%cd darknet

# Check the folder
# !ls

# Changing configuration in order to use GPU and OpenCV


#Compile Darknet
#!make

# Execute to clear the darknet directory
#%cd /content
#%rm -r darknet

# Uncomment after the first run, when you have a copy of compiled darkent in your Google Drive

# Makes a dir for darknet and move there
#!mkdir darknet
#%cd darknet

# Copy the Darkent compiled version to the VM local drive
#!cp /content/gdrive/My\ Drive/darknet/bin/darknet ./darknet

# Move to correct folder and give permission to darknet
%cd /content/gdrive/MyDrive/darknet
!chmod +x ./darknet

# Train a custom network with own dataset 
#!./darknet detector train "/content/gdrive/MyDrive/Q8/TFG/darknet-master-copy/data/train.data" "/content/gdrive/MyDrive/Q8/TFG/darknet-master-copy/cfg/yolov4-train-640.cfg" "/content/gdrive/MyDrive/Q8/TFG/darknet-master-copy/backup/yolov4-train-640_last.weights" -dont_show #-map
