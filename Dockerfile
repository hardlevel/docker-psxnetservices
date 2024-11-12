FROM ubuntu:latest
USER root
WORKDIR /var/www
RUN apt-get update && \
    apt-get autoremove -y && \
    apt-get install -y --no-install-recommends git make g++ build-essential manpages-dev

RUN git config --global http.sslverify false

RUN git clone --recursive https://github.com/dirkvdb/ps3netsrv--.git ps3netsrv && \
    cd ps3netsrv && \
    git submodule update --init && \
    make CXX=g++ && \
    mkdir /var/www/ps3 && \
    mv ./ps3netsrv++ /var/www/ps3/ps3netsrv && \
    rm -rf /var/www/ps3netsrv

RUN apt-get install -y ca-certificates curl gnupg && \
    mkdir -m 0755 -p /etc/apt/keyrings && \
    #rm /etc/apt/keyrings/teamxlink.gpg && \
    curl -fsSL https://dist.teamxlink.co.uk/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/teamxlink.gpg && \
    chmod a+r /etc/apt/keyrings/teamxlink.gpg && \
    echo  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/teamxlink.gpg] https://dist.teamxlink.co.uk/linux/debian/static/deb/release/ /" | tee /etc/apt/sources.list.d/teamxlink.list > /dev/null && \
    apt-get update && \
    apt-get install -yf libcap2-bin xlinkkai
    #kaiengine

RUN apt-get install -y samba

# RUN systemctl enable --now smb && \
# RUN systemctl enable --now nmb && \
#     systemctl enable --now firewalld && \
#     firewall-cmd --list-services cockpit dhcpv6-client ssh && \
#     firewall-cmd --add-service samba success

RUN echo "[ps2]" >> /etc/samba/smb.conf && \
    echo "   path = /var/www/ps2" >> /etc/samba/smb.conf && \
    echo "   public = yes" >> /etc/samba/smb.conf && \
    echo "   writable = yes" >> /etc/samba/smb.conf && \
    echo "   browseable = yes" >> /etc/samba/smb.conf && \
    echo "   create mask = 0777" >> /etc/samba/smb.conf && \
    echo "   directory mask = 0777" >> /etc/samba/smb.conf

RUN curl -LJO https://github.com/PSRewired/RetroDNS/releases/download/0.0.3/RetroDNS-0.0.3-linux-x64.tar.gz && \
    tar -xzf RetroDNS-0.0.3-linux-x64.tar.gz

EXPOSE 38008 34522

COPY ["./scripts.sh", "/root/scripts.sh"]
RUN chmod +x /root/scripts.sh
#RUN chmod
#CMD ["/bin/sh","/root/scripts.sh"]
#CMD ["bash", "-c", "smbd --foreground --no-process-group & kaiengine & /var/www/ps3/ps3netsrv /var/www/ps3/share && /var/www/ps2/udpbd-server ."]
CMD ["/bin/bash", "/root/scripts.sh"]