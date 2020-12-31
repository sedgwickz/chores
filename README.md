# Chores

一些自用（或许对你有用）的脚本，所有脚本不需要安装下载，一键执行。

## 批量 ping 测试云服务器速度

目前支持的云服务器如下：

- 阿里云
- 仅阿里云海外节点
- 腾讯云
- Vultr
- Linode
- DigitalOcean
- 华为云

如果你需要支持其他节点，可以提 issue

### 使用

复制以下代码到终端自动执行

```
bash <(curl -s https://raw.githubusercontent.com/sedgwickz/chores/main/scripts/ping.sh)
```

演示

![demo1](assets/demo1.gif)

## License

MIT
