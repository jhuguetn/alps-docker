FROM mrtrix3/mrtrix3:3.0.4 AS mrtrix
FROM buildpack-deps:buster AS builder

# Download minified FSL (6.0.7.7)
FROM builder AS fsl-installer
WORKDIR /opt/fsl
RUN curl -fsSL https://osf.io/ph9ex/download \
 | tar xz --strip-components 1 \
 && ln -s /opt/fsl/bin/eddy_cpu /opt/fsl/bin/eddy_openmp \
 # Prevent error with library version
 && unlink /opt/fsl/lib/libtinfo.so.6

# Build final image
FROM mrtrix AS final
COPY --from=fsl-installer /opt/fsl /opt/fsl
WORKDIR /tmp

ENV OMP_NUM_THREADS=4 \
    LD_LIBRARY_PATH="/opt/ants/lib:/opt/fsl/lib" \
    PATH="/opt/mrtrix3/bin:/opt/ants/bin:/opt/art/bin:/opt/fsl/share/fsl/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

MAINTAINER Jordi Huguet <jhuguet@barcelonabeta.org>
LABEL description="DTI-ALPS / MRtrix3 3.0.4 / FSL 6.0.7.7 docker image"
LABEL maintainer="jhuguet@barcelonabeta.org"

ENV ALPS_VERSION=bbrc-0.1
ENV ALPS_DIR=/opt/alps

# install Git, alps, FSL atlases and dependencies
RUN apt-get update \
 && apt-get install -y nano git git-lfs bc \
 && apt-get clean \
 && git clone -b bbrc https://github.com/jhuguetn/alps.git ${ALPS_DIR} \
 && cd ${ALPS_DIR} \
 && git checkout ${ALPS_VERSION} \
 && chmod +x ${ALPS_DIR}/alps.sh \
 && git clone https://git.fmrib.ox.ac.uk/fsl/data_atlases.git /tmp/atlases \
 && mkdir -p /opt/fsl/data/atlases \
 && cp -r /tmp/atlases/JHU* /opt/fsl/data/atlases/ \
 && rm -rf /tmp/atlases \
 && git clone https://git.fmrib.ox.ac.uk/fsl/flirt.git /tmp/flirt \
 && cp -r /tmp/flirt/flirtsch/* /opt/fsl/etc/flirtsch/ \
 && rm -rf /tmp/flirt

# install Python3 packages
#RUN pip3 install --no-cache-dir \
# 'bbrc-pyxnat==1.6.3.dev1'

# append ALPS and FSL binaries to system PATH
ENV PATH="${PATH}:/opt/alps:/opt/fsl/bin"

# copy scripts and run.sh entrypoint
#COPY scripts /tmp/scripts
#COPY run.sh /tmp/bin/run.sh
#RUN chmod +x /tmp/bin/run.sh

ENTRYPOINT ["alps.sh"]
