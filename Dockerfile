FROM balenalib/raspberrypi3-debian

# Set metadata
LABEL maintainer="Thomas Bendler <project@bendler-net.de>"
LABEL version="1.3"
LABEL description="Creates an Alpine container serving a CUPS instance accessible through airplay as well"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  sudo \
  locales \
  whois \
  cups \
  cups-client \
  cups-bsd \
  printer-driver-all \
  hpijs-ppds \
  hp-ppd \
  hplip \
  printer-driver-gutenprint \
  avahi-daemon \
  avahi-discover \
  libnss-mdns

RUN sed -i "s/^#\ \+\(en_US.UTF-8\)/\1/" /etc/locale.gen \
  && locale-gen en_US en_US.UTF-8

# Set environment
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV TERM xterm

# Create user
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
  && sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir /var/lib/apt/lists/partial

# Copy configuration files
#COPY root /
COPY etc/cups/cupsd.conf /etc/cups/cupsd.conf
COPY etc/cups/printers.conf /etc/cups/printers.conf

# Prepare CUPS container
RUN chmod 755 /srv/run.sh

# Expose SMB printer sharing
EXPOSE 137/udp 139/tcp 445/tcp

# Expose IPP printer sharing
EXPOSE 631/tcp

# Expose avahi advertisement
EXPOSE 5353/udp

# Start CUPS instance
CMD ["/srv/run.sh"]
