# locod-nx-docker : Docker with Nanoxplore tools

## Description

This repository contains a Dockerfile to make a Docker image with the followings components :

- **Impulse** : a proprietary design suite developed by NanoXplore that offers a complete compile design flow which transforms user HDL RTL code into a bitstream for dedicated NX devices through *Synthesise*, *Place* and *Route* software steps. It includes its own synthesis and static timing analysis tool.

- **NxBase2** : a tool developed to interact with devkit boards for NanoXplore's chips. It provides a way to upload bitstreams into the chip and is able to control some of the hardware features of the related devkits.

- **NXLMD** : this is the license server used by the different Nanoxplore tools to check user license validity.

In the context of the Locod project, these tools are used to generate the bitstream of the FPGA design for the Nanoxplore targets.

<br>

## Dependencies

To work, this dockerfile must be built in a directory with the following files:
- `nxdesignsuite-23.5.0.5.tar.gz` : installation files of NX Design Suite (Impulse)
- `NxBase2-2.5.3.tar.gz` : installation files of NxBase2
- `NXLMD-2.2-linux.tar.gz` : installation files of NXLMD
- `license.lic` : license file with a MAC address and an hostname. <span style="color:red">These two parameters will be needed to run the docker once the image built</span>

Here are the dependencies installed within the Dockerfile to make these tools working :

`python3 xorg-x11-xauth xorg-x11-server-utils gstreamer-plugins-base libwebp pulseaudio-libs-glib2 xcb-util-renderutil xcb-util-image xcb-util-keysyms xcb-util-wm vim-enhanced`

<br>

## Run command and usage

Once built, the Docker image can be used to create a container with the following command:

```console
docker run -it --rm --hostname [HOSTNAME in license.lic] --mac-address [MAC ADDR in license.lic] -v ... DOCKER_IMAGE_NAME
```

To enable the X11 display, the following command needs to be run on the host machine:
```console
xhost +
```
