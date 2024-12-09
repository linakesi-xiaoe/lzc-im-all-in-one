# Pull base image.
FROM registry.lazycat.cloud/kasm-debian-bookworm:0.0.1
USER root

RUN usermod -l lazycat kasm-user
RUN echo 'lazycat ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
ENV HOME /home/lazycat
WORKDIR $HOME
RUN sudo apt-get update;  sudo apt-get install -y telegram-desktop firefox-esr wget xdg-utils
RUN wget https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb; sudo dpkg -i WeChatLinux_x86_64.deb; wget https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.13_241121_amd64_01.deb; sudo dpkg -i QQ_3.2.13_241121_amd64_01.deb;rm *.deb;
RUN sed -i 's/kasm_user/lazycat/g' /dockerstartup/vnc_startup.sh
RUN sed -i '5i sudo chown -R lazycat:kasm-user /home/lazycat/' /dockerstartup/kasm_default_profile.sh
RUN cat /dockerstartup/kasm_default_profile.sh
COPY --chown=lazycat:kasm-user kasmvnc.yaml /home/lazycat/.vnc/kasmvnc.yaml
COPY --chown=lazycat:kasm-user desktop/firefox.desktop /home/lazycat/Desktop/
COPY --chown=lazycat:kasm-user desktop/qq.desktop /home/lazycat/Desktop/
COPY --chown=lazycat:kasm-user desktop/telegram.desktop /home/lazycat/Desktop/
COPY --chown=lazycat:kasm-user desktop/wechat.desktop /home/lazycat/Desktop/

COPY --chown=lazycat:kasm-user desktop/qq.desktop /home/lazycat/.config/autostart/
COPY --chown=lazycat:kasm-user desktop/telegram.desktop /home/lazycat/.config/autostart/
COPY --chown=lazycat:kasm-user desktop/wechat.desktop /home/lazycat/.config/autostart/

RUN chmod +x /home/lazycat/Desktop/*.desktop
RUN chmod +x /home/lazycat/.config/autostart/*.desktop
ENV VNCOPTIONS "-PreferBandwidth -disableBasicAuth -DynamicQualityMin=4 -DynamicQualityMax=7 -DLP_ClipDelay=0 -sslOnly=0"
ENV VNC_PW lazycat

USER lazycat
