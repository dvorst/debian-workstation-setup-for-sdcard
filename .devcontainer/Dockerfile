FROM docker.io/debian:unstable

COPY dat/ /

# COPY might change the permissions of /tmp, restore them
RUN chmod 1777 /tmp

ARG USERNAME

# Root password, is used only in the devcontainer, so having it show up in the logs is fine
ARG ROOT_PASSWORD

# Scripts directory, which will be added to the path for convenience
ARG SCRIPTS_DIR

# Terminal editor to install
ARG TERMINAL_EDITOR

# No cache is used with the RUN commands
#   I don't expect this image will change often, not using RUN cache prevents podman volumes from
#   bloating up / taking up space.
# A single bash script is used instead of seperate RUN commands
#   Debugging Dockerfiles is generally incredibly slow, developping the script from within an
#   empty base container is a far more convenient development experience.
RUN bash /tmp/setup.sh \
    --create-user $USERNAME \
    --set-root-password $ROOT_PASSWORD \
    --add-to-path "$SCRIPTS_DIR" \
    --apt-package $TERMINAL_EDITOR \
    --apt-package graphviz \
    --apt-package buildah \
    --apt-package shfmt \
    --apt-package ble.sh \
    --apt-package starship \
    --apt-package bat \
    --install uv

# Set the default user to the one created in setup.sh
USER $USERNAME
