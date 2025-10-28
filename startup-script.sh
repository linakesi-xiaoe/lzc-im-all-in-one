#!/bin/bash
set -ex

mkdir -p /home/lazycat/lzc-home
sudo /home/lazycat/mount-mappied --map-mount b:0:1000:1 /lzcapp/run/mnt/home /home/lazycat/lzc-home

xfce4-panel --add=systray --display=:1.0
ln -svfn /lzcapp/var '/home/lazycat/Desktop/本应用数据(支持读写)'
ln -svfn /home/lazycat/lzc-home '/home/lazycat/Desktop/懒猫网盘数据(支持读写，请谨慎操作)'
# 默认启动ime
sudo sed -i "s/UI.initSetting('enable_ime', false)/UI.initSetting('enable_ime', true)/g" /usr/share/kasmvnc/www/dist/main.bundle.js
