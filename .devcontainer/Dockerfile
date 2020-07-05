ARG VARIANT="5.0"
FROM mcr.microsoft.com/dotnet/core/sdk:${VARIANT}-alpine

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ADD common-script.sh /tmp
RUN apk update \
    && /bin/ash /tmp/common-script.sh "${USERNAME}" "${USER_UID}" "${USER_GID}" \
    && rm /tmp/common-script.sh