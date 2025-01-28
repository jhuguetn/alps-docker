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

ENV LD_LIBRARY_PATH="/opt/ants/lib:/opt/fsl/lib" \
    PATH="/opt/alps:/opt/fsl/bin:/opt/mrtrix3/bin:/opt/ants/bin:/opt/art/bin:/opt/fsl/share/fsl/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

MAINTAINER Jordi Huguet <jhuguet@barcelonabeta.org>
LABEL description="DTI-ALPS / MRtrix3 3.0.4 / FSL 6.0.7.7 docker image"
LABEL maintainer="jhuguet@barcelonabeta.org"

ENV ALPS_REPO_VERSION b212e4c
ENV ALPS_VERSION ${ALPS_REPO_VERSION}

# install Git, alps, FSL atlases and dependencies
RUN apt-get update \
 && apt-get install -y nano git git-lfs bc \
 && apt-get clean \
 && git clone -b main https://github.com/gbarisano/alps.git /opt/alps \
 && chmod +x /opt/alps/alps.sh \
 && cd /opt/alps \
 && git checkout ${ALPS_REPO_VERSION} \
 && git clone https://git.fmrib.ox.ac.uk/fsl/data_atlases.git /tmp/atlases \
 && mkdir -p /opt/fsl/data/atlases \
 && cp -r /tmp/atlases/JHU* /opt/fsl/data/atlases/ \
 && rm -rf /tmp/atlases

# install Python3 packages
#RUN pip3 install --no-cache-dir \
# 'bbrc-pyxnat==1.6.3.dev1'

# copy scripts and run.sh entrypoint
#COPY scripts /tmp/scripts
#COPY run.sh /tmp/bin/run.sh
#RUN chmod +x /tmp/bin/run.sh

ENTRYPOINT ["alps.sh"]
