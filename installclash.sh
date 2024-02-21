echo "开始安装ClashMeta"
apt install curl wget -y
mkdir /docker
mkdir /docker/clash
work=/docker/clash/

latest_version=$(wget -qO- -t1 -T2 "https://api.github.com/repos/MetaCubeX/mihomo/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's>
wget -4 https://github.com/MetaCubeX/mihomo/releases/download/$latest_version/mihomo-linux-amd64-compatible-go120-$latest_version.gz -O mihomo.gz
gzip -d mihomo.gz -f
mv mihomo /docker/clash/mihomo
chmod +x /docker/clash/mihomo
now_version=$(/docker/clash/mihomo -v | grep Mihomo | awk '{print$3}')
wget -4 https://raw.githubusercontent.com/gentle95/oMoooTo/main/Clash.Meta.yaml -O /docker/clash/Clash.Meta.yaml

echo "安装Clash服务"
touch /etc/systemd/system/clash.service

echo "[Unit]
Description=Clash Service
After=network.target

[Service]
Type=simple
LimitNPROC=500
LimitNOFILE=1000000
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH
ExecStartPre=/usr/bin/sleep 1s
ExecStart=/docker/clash/mihomo -f /docker/clash/Clash.Meta.yaml
Restart=always
User=root
#WorkingDirectory=/docker/clash
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=default.target" | tee -a /etc/systemd/system/clash.service

echo "重新载入服务"
systemctl daemon-reload
echo "开启Clash服务"
systemctl enable clash.service
echo "启动Clash服务"
systemctl start clash.service
echo "安装结束"
echo "当前Mihomo版本号：$now_version"
