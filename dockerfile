# Use an official Ubuntu image
FROM ubuntu:latest

# Set environment variables (DEBIAN_FRONTEND to avoid interactive menus with apt-get)
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    bash \
    sudo \
    build-essential \
    git \
    flake8 \
    pylint && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add a user and give them sudo access without a password
ARG UID=1001
ARG GID=1001
ARG UNAME=runner
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME
RUN echo "$UNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$UNAME && \
    chmod 0440 /etc/sudoers.d/$UNAME
USER $UNAME
WORKDIR /home/$UNAME

# Download and install TiCS
ENV TICSFSCACHE=/var/tmp/$USER
RUN curl -o /home/runner/install_tics.sh -l "https://canonical.tiobe.com/tiobeweb/TICS/api/public/v1/fapi/installtics/Script?cfg=default&platform=linux&url=https://canonical.tiobe.com/tiobeweb/TICS/"
RUN chmod +x /home/runner/install_tics.sh
# We need to mount the secret with our second user ('runner', first is 'ubuntu')
RUN --mount=type=secret,id=env,uid=$UID \
    export TICSAUTHTOKEN=$(cat /run/secrets/env) && \
    /home/runner/install_tics.sh

#Set environment variables one by one (as 'source /root/.profile' is not persistent)
ENV PATH=/home/runner/TICS/Wrapper/BuildServer:$PATH
ENV PATH=/home/runner/Wrapper/Client:$PATH
ENV TICS="https://canonical.tiobe.com/tiobeweb/TICS/api/cfg?name=default"
ENV TICSPROJECT="auto"

#This command indirectly pulls and installs Coverity and other artificts (they are not triggered by the install script)
RUN --mount=type=secret,id=env,uid=$UID \
    export TICSAUTHTOKEN=$(cat /run/secrets/env) && \
    TICSMaintenance -checkchk

# Entry point script/right entrypoint/CMD to be explored
ENTRYPOINT ["/bin/bash"]
