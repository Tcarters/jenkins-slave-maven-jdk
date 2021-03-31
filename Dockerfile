FROM centos:latest

LABEL maintainer="Tchamie Edmond  <tchamieedmond@gmail.com>"

# Make sure the package repository is up to date.
RUN yum  update  -y && \
    yum  install -qy git && \
    yum  install -qy net-tools && \

# Install a basic SSH server
    yum install -qy openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    echo 'docker' > /run/systemd/container \

# Install JDK 8 (latest stable edition)
    yum install -qy openjdk-8-jdk && \

# Install maven
    yum  install -qy maven && \

# Cleanup old packages
    yum  clean all -y  && \

# Add user jenkins to the image to allow after connection from outside to our jenkins user in container
    adduser  jenkins && \

# Set password for the jenkins user (you may want to alter this).
    echo "jenkins:jenkins" | chpasswd && \
    mkdir /home/jenkins/.m2 && \
    mkdir /home/jenkins/.ssh


# Create  authorized keys
RUN  ssh-keygen -A

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

# Standard SSH port exposed for outside connection to our container
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
