# locod-nx-docker : Docker with Nanoxplore tools

## Description

This repository contains a Dockerfile to make a Docker image with the followings components :

- **Impulse** : a proprietary design suite developed by NanoXplore that offers a complete compile design flow which transforms user HDL RTL code into a bitstream for dedicated NX devices through *Synthesise*, *Place* and *Route* software steps. It includes its own synthesis and static timing analysis tool.

- **NxBase2** : a tool developed to interact with devkit boards for NanoXplore's chips. It provides a way to upload bitstreams into the chip and is able to control some of the hardware features of the related devkits.

- **NXLMD** : this is the license server used by the different Nanoxplore tools to check user license validity.

- **nx_embedded_tools** : a toolsuite written in python3 that allow user to control the NGUltra chip. The repository contains as a submodule OpenOCD to connect to the NG-Ultra board via a JTAG probe

In the context of the Locod project, these tools are used to generate the bitstream of the FPGA design for the Nanoxplore targets.

<br>

## Dependencies

To work, this dockerfile must be built in a directory with the following files:
- `nxdesignsuite-23.5.1.2.tar.gz` : installation files of NX Design Suite (Impulse)
- `NxBase2-2.5.3.tar.gz` : installation files of NxBase2
- `NXLMD-2.2-linux.tar.gz` : installation files of NXLMD
- `license.lic` : license file with a MAC address and an hostname. <span style="color:red">These two parameters will be needed to run the docker once the image built</span>

To build the Docker image, it is necessary to have credits on the NanoXplore GitLab to access the nx_embedded_tools repository:
- **NX_USERNAME** : username on the NanoXplore Gitlab
- **NX_PERSONAL_ACCESS_TOKEN** : Personal Access Token generated on the NanoXplore Gitlab to have the rights to pull the repository with https.

<br>

## Image build

Assuming that the necessary files are in the **$BUILD_CONTEXT** folder, and that the credits for Gitlab Nanoxplore are defined by the **$NX_USERNAME** and **$NX_PERSONAL_ACCESS_TOKEN** variables, the Docker image can then be built using the following command:

```console
docker build -t ${IMG_NAME} --build-arg NX_USERNAME=${NX_USERNAME} --build-arg NX_PERSONAL_ACCESS_TOKEN=${NX_PERSONAL_ACCESS_TOKEN} -f Dockerfile ${BUILD_CONTEXT}
```

<br>

## Run command and usage

Before launching the Docker image, some configurations must be done on the host machine to be able to use all the features of the created Docker image.

Indeed, to access the USB devices connected to the machine with OpenOCD installed in the Docker image, you need to add uDev rules to configure the connected devices. These uDev rules must be added on the host machine:

```console
sudo curl https://raw.githubusercontent.com/openocd-org/openocd/master/contrib/60-openocd.rules --output /etc/udev/rules.d/60-openocd.rules
sudo udevadm control --reload-rules && sudo udevadm trigger
sudo usermod -a -G plugdev $USER
```

The Docker image can then be launched with the following command:

```console
docker run -it --rm -u $(id -u):$(id -g) --hostname [HOSTNAME in license.lic] --mac-address [MAC ADDR in license.lic] -v ... --privileged ${IMG_NAME}
```

The **--privileged** option in the run command allow the Docker container to acces devices of the host machine as USB devices.
