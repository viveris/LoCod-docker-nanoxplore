FROM centos:7
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
MAINTAINER Julien ARMENGAUD <julien.armengaud@viveris.fr>
LABEL description="Docker with NanoXplore tools"


# Copy NanoXplore tools to docker
COPY NxBase2-2.5.3.tar.gz /opt/NanoXplore/NxBase2-2.5.3.tar.gz
COPY nxdesignsuite-22.3.0.2.tar.gz /opt/NanoXplore/nxdesignsuite-22.3.0.2.tar.gz
COPY NXLMD-2.2-linux.tar.gz /opt/NanoXplore/NXLMD-2.2-linux.tar.gz


# Decompressing  NanoXplore tools
RUN 	cd /opt/NanoXplore && \
	tar xvf NxBase2-2.5.3.tar.gz && \
	tar xvf nxdesignsuite-22.3.0.2.tar.gz && \
	tar xvf NXLMD-2.2-linux.tar.gz && \
	rm -rf NxBase2-2.5.3.tar.gz && \
	rm -rf nxdesignsuite-22.3.0.2.tar.gz && \
	rm -rf NXLMD-2.2-linux.tar.gz


# Add NanoXplore executables to PATH
ENV PATH=/opt/NanoXplore/NxBase2-2.5.3/other_os/nxbase2_cli:$PATH
ENV PATH=/opt/NanoXplore/nxdesignsuite-22.3.0.2/bin:$PATH
ENV PATH=/opt/NanoXplore/NXLMD/2.2/bin:$PATH


# Setting up serveur license
COPY license.lic /opt/NanoXplore/NXLMD/2.2/license.lic
RUN 	cd /opt/NanoXplore/NXLMD/2.2/bin $$ \
	ln -sfn x86_64_RHEL_7/lmgrd lmgrd && \
	ln -sfn x86_64_RHEL_7/lmhostid lmhostid && \
	ln -sfn x86_64_RHEL_7/lmstat lmstat && \
	ln -sfn x86_64_RHEL_7/lmutil lmutil && \
	ln -sfn x86_64_RHEL_7/NXLMD NXLMD && \
	ln -sfn x86_64_RHEL_7/lmadmin lmadmin
RUN ln -s /lib64/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
ENV LM_LICENSE_FILE=/opt/NanoXplore/NXLMD/2.2/license.lic


# Adding packages for X11 display
RUN yum -y update; yum clean all
RUN yum -y install python3 xorg-x11-xauth xorg-x11-server-utils gstreamer-plugins-base libwebp pulseaudio-libs-glib2 xcb-util-renderutil xcb-util-image xcb-util-keysyms xcb-util-wm vim-enhanced; yum clean all


# Workdir
WORKDIR /root


# Start command
CMD lmgrd;sleep 1;bash