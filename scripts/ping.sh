#!/bin/bash

set -e

Aliyun=(
    # 谷歌:google.com
    杭州:oss-cn-hangzhou.aliyuncs.com
    上海:oss-cn-shanghai.aliyuncs.com
    青岛:oss-cn-qingdao.aliyuncs.com
    北京:oss-cn-beijing.aliyuncs.com
    张家口:oss-cn-zhangjiakou.aliyuncs.com
    呼和浩特:oss-cn-huhehaote.aliyuncs.com
    深圳:oss-cn-shenzhen.aliyuncs.com
    河源:oss-cn-heyuan.aliyuncs.com
    成都:oss-cn-chengdu.aliyuncs.com
    香港:oss-us-west-1.aliyuncs.com
    弗吉尼亚:oss-us-east-1.aliyuncs.com
    新加坡:oss-ap-southeast-1.aliyuncs.com
    悉尼:oss-ap-southeast-2.aliyuncs.com
    吉隆坡:oss-ap-southeast-3.aliyuncs.com
    雅加达:oss-ap-southeast-5.aliyuncs.com
    东京:oss-ap-northeast-1.aliyuncs.com
    孟买:oss-ap-south-1.aliyuncs.com
    法兰克福:oss-eu-central-1.aliyuncs.com
    伦敦:oss-eu-west-1.aliyuncs.com
    迪拜:oss-me-east-1.aliyuncs.com
)

Vultr=(
    法兰克福:fra-de-ping.vultr.com
    巴黎:par-fr-ping.vultr.com
    阿姆斯特丹:ams-nl-ping.vultr.com
    伦敦:lon-gb-ping.vultr.com
    新加坡:sgp-ping.vultr.com
    纽约:nj-us-ping.vultr.com
    东京:hnd-jp-ping.vultr.com
    多伦多:tor-ca-ping.vultr.com
    芝加哥:il-us-ping.vultr.com
    亚特兰大:ga-us-ping.vultr.com
    迈阿密:fl-us-ping.vultr.com
    西雅图:wa-us-ping.vultr.com
    达拉斯:tx-us-ping.vultr.com
    硅谷:sjo-ca-us-ping.vultr.com
    洛杉矶:syd-au-ping.vultr.com
)

Linode=(
    日本:speedtest.tokyo2.linode.com
    孟买:speedtest.mumbai1.linode.com
    新加坡:speedtest.singapore.linode.com
    悉尼:speedtest.syd1.linode.com
    法兰克福:speedtest.frankfurt.linode.com
    伦敦:speedtest.london.linode.com
    多伦多:speedtest.toronto1.linode.com
    "纽瓦克(US):speedtest.newark.linode.com"
    亚特兰大:speedtest.atlanta.linode.com
    达拉斯:speedtest.dallas.linode.com
    "菲蒙市(US):speedtest.fremont.linode.com"
)

DigitalOcean=(
    纽约2:speedtest-nyc2.digitalocean.com
    纽约3:speedtest-nyc3.digitalocean.com
    旧金山:speedtest-sfo1.digitalocean.com
    阿姆斯特丹2:speedtest-ams2.digitalocean.com
    阿姆斯特丹3:speedtest-ams3.digitalocean.com
    新加坡:speedtest-sgp1.digitalocean.com
    伦敦:speedtest-lon1.digitalocean.com
    法兰克福:speedtest-fra1.digitalocean.com
)

test_nodes=()
echo '-----------------------------------------------------------'
options=( 1.所有云服务器 2.阿里云 3.Vultr 4.Linode 5.DigitalOcean 6.Quit )
for op in ${options[@]}; do
    echo -e "${op}"
done
read -p '请选择你要测试的云服务器(default: 1):' input
case $input in
    1)
        test_nodes=("${Aliyun[@]}" "${Vultr[@]}" "${Linode[@]}" "${DigitalOcean[@]}")        
        ;;
    2)
        test_nodes=${Aliyun[@]}  
        ;;
    3)
        test_nodes=${Vultr[@]}  
        ;;
    4)
        test_nodes=${Linode[@]}  
        ;;
    5)
        test_nodes=${DigitalOcean[@]}  
        ;;
    6)
        exit 1
        ;;
    7)
        test_nodes=("测试:google.com")
        ;;
    *)
        test_nodes=("${Aliyun[@]}" "${Vultr[@]}" "${Linode[@]}" "${DigitalOcean[@]}")    
        ;;
esac
echo '----------------------------------------------------------'

pings=""

for url in ${test_nodes[@]}; do
    region_name=${url%:*}
    region_url=${url##*:}
    text="$(ping -t 3 -c 3 ${region_url}; echo $?)"
    if [[ "${text}" == "68" ]]; then
        echo ${region_name} ${region_url} "无法解析"
        continue
    fi
    ping_result=$(echo ${text} | tail -n 1)
    result="${region_name} ${region_url} $(echo ${ping_result##*min/avg/max/stddev} | cut -d "/" -f 2) ms"
    is_time_out=$(echo ${result} | grep -o " " | wc -l)
    if [[ ${is_time_out} -gt 3 ]]; then
        echo ${region_name} ${region_url} "请求超时"
    else
        pings+="${result}\n"
        echo ${result}
    fi
done

echo 
echo "########################### Top3 #############################"
echo -e $pings | sort -k 3n | head -n 4
