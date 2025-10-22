# Pull base image.
FROM registry.lazycat.cloud/kasm-debian-bookworm:0.0.1
USER root

RUN usermod -l lazycat kasm-user
RUN echo 'lazycat ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
ENV HOME /home/lazycat
WORKDIR $HOME
RUN apt-get update && \
    apt-get install -y \
        firefox-esr wget xdg-utils \
        shared-mime-info desktop-file-utils \
        libgtk-3-0 libglib2.0-0 libnspr4 libnss3 \
        libx11-6 libx11-xcb1 libxcomposite1 libxdamage1 libxext6 libxfixes3 \
        libxi6 libxrandr2 libxrender1 libxkbcommon-x11-0 libxss1 libxtst6 \
        libatk1.0-0 libatk-bridge2.0-0 libcairo2 libpango-1.0-0 libpangocairo-1.0-0 \
        libcups2 libdbus-1-3 libfontconfig1 libgbm1 libstdc++6 libgcc-s1 libc6 \
        libxcb1 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render0 \
        libxcb-render-util0 libxcb-shape0 libxcb-shm0 libxcb-sync1 libxcb-util1 \
        libxcb-xfixes0 libxcb-xinerama0 libxcb-glx0 libatomic1 gdb && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    wget https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb -O wechat.deb && \
    dpkg -i wechat.deb || apt-get -f install -y && \
    wget https://dldir1v6.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.19_250904_amd64_01.deb -O qq.deb && \
    dpkg -i qq.deb || apt-get -f install -y && \
    rm *.deb && \
    wget -O "/usr/share/keyrings/xpra.asc" https://xpra.org/xpra.asc && \
    wget -O "/etc/apt/sources.list.d/xpra.sources" https://raw.githubusercontent.com/Xpra-org/xpra/master/packaging/repos/bookworm/xpra.sources && \
    apt-get update && apt-get install -y xpra && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/kasm_user/lazycat/g' /dockerstartup/vnc_startup.sh
RUN sed -i '5i sudo chown -R lazycat:kasm-user /home/lazycat/' /dockerstartup/kasm_default_profile.sh
RUN cat /dockerstartup/kasm_default_profile.sh
COPY --chown=lazycat:kasm-user kasmvnc.yaml /home/lazycat/.vnc/kasmvnc.yaml
COPY --chown=lazycat:kasm-user desktop/firefox.desktop /home/lazycat/Desktop/
COPY --chown=lazycat:kasm-user desktop/qq.desktop /home/lazycat/Desktop/
COPY --chown=lazycat:kasm-user desktop/wechat.desktop /home/lazycat/Desktop/

COPY --chown=lazycat:kasm-user desktop/qq.desktop /home/lazycat/.config/autostart/
COPY --chown=lazycat:kasm-user desktop/wechat.desktop /home/lazycat/.config/autostart/
COPY --chown=lazycat:kasm-user desktop/startup-script.desktop /home/lazycat/.config/autostart/
COPY --chown=lazycat:kasm-user startup-script.sh /home/lazycat/.config/autostart/
COPY --chown=lazycat:kams-user mount-mappied /home/lazycat/
COPY --chown=lazycat:kams-user wechat_gdb.py /home/lazycat/Desktop/wechat_gdb.py

RUN chmod +x /home/lazycat/Desktop/*.desktop
RUN chmod +x /home/lazycat/.config/autostart/*.desktop
ENV VNCOPTIONS "-PreferBandwidth -disableBasicAuth -FrameRate=60 -DLP_ClipDelay=0 -sslOnly=0"
ENV VNC_PW lazycat

USER lazycat
