FROM alpine
#
# BUILD:
#   wget https://raw.githubusercontent.com/thbe/docker-cups/master/Dockerfile
#   docker build --rm --no-cache -t thbe/cups .
#
# USAGE:
#   wget https://raw.githubusercontent.com/thbe/docker-cups/master/start_cups.sh
#   ./start_cups.sh
#

# Set metadata
LABEL maintainer="Thomas Bendler <project@bendler-net.de>"
LABEL version="1.2"
LABEL description="Creates an Alpine container serving a CUPS instance with built in airplay"

# Set environment
ENV LANG en_US.UTF-8
ENV TERM xterm

# Set workdir
WORKDIR /opt/cups

# Install CUPS/AVAHI
RUN apk add --no-cache cups cups-filters

# Configure CUPS
COPY ./cupsd.conf /etc/cups/cupsd.conf

# Install PPDs
# COPY ppd /etc/cups/ppd

# Prepare CUPS start
COPY ./run.sh /opt/cups/run.sh
RUN chmod 755 /opt/cups/run.sh

# Expose SMB printer sharing
EXPOSE 137/udp 139/tcp 445/tcp

# Expose IPP printer sharing
EXPOSE 631/tcp 5353/udp

# Reconfigure and start CUPS instance
CMD ["/opt/cups/run.sh"]
