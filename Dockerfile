FROM alpine:latest

RUN apk upgrade && apk add --no-cache binutils build-base libatomic git openssh-server python3 python3-dev py3-setuptools py3-numpy py3-scipy py3-pip py3-mpi4py gcc musl-dev gfortran openmpi-dev openmpi
RUN ssh-keygen -A && mkdir /var/run/sshd && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN echo "export VISIBLE=now" >> /etc/profile

ENV USER root
ENV HOME /${USER}

ENV SSHDIR ${HOME}/.ssh/
RUN mkdir -p ${SSHDIR}

ADD ssh/config ${SSHDIR}/config
ADD ssh/id_rsa.mpi ${SSHDIR}/id_rsa
ADD ssh/id_rsa.mpi.pub ${SSHDIR}/id_rsa.pub
ADD ssh/id_rsa.mpi.pub ${SSHDIR}/authorized_keys

RUN chmod -R 600 ${SSHDIR}* && \
    chown -R ${USER}:${USER} ${SSHDIR}

RUN rm -fr ${HOME}/.openmpi && mkdir -p ${HOME}/.openmpi
ADD default-mca-params.conf ${HOME}/.openmpi/mca-params.conf
RUN chown -R ${USER}:${USER} ${HOME}/.openmpi
ENV TRIGGER 1 && \
    OMPI_ALLOW_RUN_AS_ROOT 1 && \
    OMPI_ALLOW_RUN_AS_ROOT_CONFIRM 1 &&

ADD mpi4py_benchmarks ${HOME}/mpi4py_benchmarks
RUN chown -R ${USER}:${USER} ${HOME}/mpi4py_benchmarks

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
