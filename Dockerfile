# Pull base image.
FROM registry.lazycat.cloud/kasm-debian-bookworm:0.0.1
USER root

RUN usermod -l lazycat kasm-user
RUN echo 'lazycat ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
ENV HOME /home/lazycat
WORKDIR $HOME
RUN sudo apt-get update;  sudo apt-get install -y firefox-esr wget xdg-utils; apt install -y \
    shared-mime-info desktop-file-utils libxcb1 libxcb-icccm4 libxcb-image0 \
    libxcb-keysyms1 libxcb-randr0 libxcb-render0 libxcb-render-util0 libxcb-shape0 \
    libxcb-shm0 libxcb-sync1 libxcb-util1 libxcb-xfixes0 libxcb-xkb1 libxcb-xinerama0 \
    libxcb-xkb1 libxcb-glx0 libatk1.0-0 libatk-bridge2.0-0 libc6 libcairo2 libcups2 \
    libdbus-1-3 libfontconfig1 libgbm1 libgcc-s1 libgdk-pixbuf2.0-0 libglib2.0-0 \
    libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 \
    libxcomposite1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 \
    libxss1 libxtst6 libatomic1 libxcomposite1 libxrender1 libxrandr2 libxkbcommon-x11-0 \
    libfontconfig1 libdbus-1-3 libnss3 libx11-xcb1 && \apt clean && \
    rm -rf /var/lib/apt/lists/* && wget https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb; sudo dpkg -i WeChatLinux_x86_64.deb; wget https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.13_241121_amd64_01.deb; sudo dpkg -i QQ_3.2.13_241121_amd64_01.deb;rm *.deb;
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

RUN chmod +x /home/lazycat/Desktop/*.desktop
RUN chmod +x /home/lazycat/.config/autostart/*.desktop
ENV VNCOPTIONS "-PreferBandwidth -disableBasicAuth -DynamicQualityMin=4 -DynamicQualityMax=7 -DLP_ClipDelay=0 -sslOnly=0"
ENV VNC_PW lazycat

USER lazycat
