FROM centos:7
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
MAINTAINER Julien ARMENGAUD <julien.armengaud@viveris.fr>
LABEL description="Docker with NX Design Suite version 23.5"

# Arguments
ARG     NX_USERNAME
ARG     NX_PERSONAL_ACCESS_TOKEN


# Download NanoXplore tools to docker
COPY    NxBase2-2.5.3.tar.gz /opt/NanoXplore/NxBase2-2.5.3.tar.gz
COPY    nxdesignsuite-23.5.0.5.tar.gz /opt/NanoXplore/nxdesignsuite-23.5.0.5.tar.gz
COPY    NXLMD-2.2-linux.tar.gz /opt/NanoXplore/NXLMD-2.2-linux.tar.gz


# Decompressing  NanoXplore tools
RUN     cd /opt/NanoXplore && \
        tar xvf NxBase2-2.5.3.tar.gz && \
        tar xvf nxdesignsuite-23.5.0.5.tar.gz && \
        tar xvf NXLMD-2.2-linux.tar.gz && \
        rm -rf NxBase2-2.5.3.tar.gz && \
        rm -rf nxdesignsuite-23.5.0.5.tar.gz && \
        rm -rf NXLMD-2.2-linux.tar.gz


# Copy license file
COPY    license.lic /opt/NanoXplore/NXLMD/2.2/license.lic


# Setting permissions
RUN     chmod -R 755 /opt/NanoXplore/


# Setting up serveur license
RUN     cd /opt/NanoXplore/NXLMD/2.2/bin && \
        ln -sfn x86_64_RHEL_7/lmgrd lmgrd && \
        ln -sfn x86_64_RHEL_7/lmhostid lmhostid && \
        ln -sfn x86_64_RHEL_7/lmstat lmstat && \
        ln -sfn x86_64_RHEL_7/lmutil lmutil && \
        ln -sfn x86_64_RHEL_7/NXLMD NXLMD && \
        ln -sfn x86_64_RHEL_7/lmadmin lmadmin
RUN     ln -s /lib64/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
ENV     LM_LICENSE_FILE=/opt/NanoXplore/NXLMD/2.2/license.lic


# Add NanoXplore executables to PATH
ENV     PATH=/opt/NanoXplore/NxBase2-2.5.3/other_os/nxbase2_cli:$PATH
ENV     PATH=/opt/NanoXplore/nxdesignsuite-23.5.0.5/bin:$PATH
ENV     PATH=/opt/NanoXplore/NXLMD/2.2/bin:$PATH


# Adding packages requirements
RUN     yum -y update && \
        yum -y install gcc python3 python3-devel xorg-x11-xauth xorg-x11-server-utils gstreamer-plugins-base libwebp pulseaudio-libs-glib2 xcb-util-renderutil xcb-util-image xcb-util-keysyms xcb-util-wm vim && \
        yum clean all


# Adding extra packages for NX Embedded tools
RUN     yum -y install git libusbx-devel bzip2 make libtool pkgconfig autoconf texinfo libusb telnet && \
        yum clean all


# Install Automake 1.16.1 (min 1.14 requiered to build OpenOCD)
RUN     cd /opt && \
        curl http://ftp.gnu.org/gnu/automake/automake-1.16.1.tar.gz --output automake-1.16.1.tar.gz && \
        tar -xzvf automake-1.16.1.tar.gz && \
        rm -rf automake-1.16.1.tar.gz && \
        cd automake-1.16.1/ && \
        ./configure && \
        make && \
        make install
ENV     ACLOCAL_PATH=/usr/share/aclocal


# Install NX Embedded tools
RUN     cd /opt && \
        git clone --recursive https://${NX_USERNAME}:${NX_PERSONAL_ACCESS_TOKEN}@gitlabext.nanoxplore.com/nx_sw_embedded/tools/nx_embedded_tools.git && \
        cd /opt/nx_embedded_tools && \
        ./setup.sh


# Add NX Embedded tools executables to PATH
ENV     PATH=/opt/nx_embedded_tools/py:$PATH
ENV     NX_EMBEDDED_TOOLS_IFACE=openocd


# Workdir
RUN     mkdir /workdir
RUN     chmod -R 777 /workdir
WORKDIR /workdir

