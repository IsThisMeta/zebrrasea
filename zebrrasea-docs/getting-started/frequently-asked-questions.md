# Frequently Asked Questions

Read about some frequently asked questions related to ZebrraSea, development, and getting support for ZebrraSea!

## Modules

### How Do I Install a "Module"?

The software, or as used in ZebrraSea, _Modules_, are all pieces of software that must be installed on a home computer or server. None of the currently supported software has been developed by me, so the amount of support offered for each module is limited. ZebrraSea itself does not have the functionality of that software, it acts as a remote.

### Why Isn't Feature/Module "X" Supported Yet?

ZebrraSea is only developed by one person and while I try to put as much time into ZebrraSea as I can, I still do have a family, career, and I want to enjoy my personal time.

I also want to point out that I don't want to make ZebrraSea a wide ranging but no depth application. I want every application to have as full of an implementation as possible, which can mean that new modules will take time to get implemented between one another.

### Torrent Client Support: Is It Coming?

Support for torrent clients is easily the most requested new module, and I definitely see the demand. However, torrent support currently is not possible in ZebrraSea because of the restrictions Apple has put forward. Apple does not allow integration of P2P/torrent clients in any capacity for applications that are hosted on the App Store. This includes a P2P client that runs directly on the device and linking to a P2P client that is running on an external machine.

Torrent support is not completely off the table and may come in the future! But at the moment, over 90% of the active user base is using iOS-based devices and it is hard to justify building a module (that takes a lot of time) that the mass majority of the user base would not be able to use.

{% hint style="info" %}
I am actively thinking of methods to get around this limitation, if you have any ideas consider commenting on the torrent client support [feedback board request](https://feedback.zebrrasea.app/b/New-Modules/p/torrent-clients-support).
{% endhint %}

## Development

### Who Makes ZebrraSea?

ZebrraSea is an open-source project developed by the community. We encourage anyone who is interested and wants to contribute to the project to make a pull request on GitHub!

### What is ZebrraSea Developed In?

ZebrraSea is developed using Google's hybrid framework, [Flutter](https://flutter.dev/), which uses [Dart](https://dart.dev/) as its core language. Using Flutter allows an indie developer like myself to build cross-platform applications more easily, as it is one single codebase that allows me to build across many platforms!

### How is ZebrraSea Free?

ZebrraSea started off as (and still is) a passion project fueled by my love for data hoarding. It was open-sourced soon after it's initial launch to allow ZebrraSea to get into the hands of as many users as possible and to give back to the community where there is a lack of open-source, high quality mobile applications.

### Are You Ever Going To Charge Money/Insert Ads?

The only possible reason that ZebrraSea will ever have any kind of payment model is if features are introduced that cost me recurring charges that are too large to bear. Any and all features that do not incur me a charge will be free, and even any features that would cost me money will become open-source, which offers everyone the ability to have a completely free experience in ZebrraSea.

## Bugs & Feedback

### I Found a Bug! How Do I Let You Know?

I tried to make it as stable as possible, but bugs obviously will always be there. If you do run into a bug (especially a fatal/crashing bug), please also attach the logs from the application into the report - logs can be exported from the settings.

* [GitHub Issues](https://www.zebrrasea.app/github): The best place to alert me of new issues is directly on the GitHub page. Please try to follow the template for bug reports, but again I am not overly strict and a good explanation of the issue will suffice (this may change in the future if it gets increasingly hard to manage).
* [Discord](https://www.zebrrasea.app/discord)
* [Email](https://docs.zebrrasea.appmailto:hello@zebrrasea.app/)
* [Reddit](https://www.zebrrasea.app/reddit)

### How Can I Request a New Feature?

I consider all feedback and actively try to integrate new features that are requested by the community, big or small! You have a few ways to request new features for ZebrraSea:

* [Discord](https://www.zebrrasea.app/discord)
* [Email](https://docs.zebrrasea.appmailto:hello@zebrrasea.app/)
* [Reddit](https://www.zebrrasea.app/reddit)

{% hint style="info" %}
I may not have the ability to respond to all requests directly, but please be ensured I do read everything!
{% endhint %}

## Support

### Why Don't The Settings Explain Much?

I understand that the settings section could definitely use better documentation and linking, but this ambiguity and sparse documentation directly within ZebrraSea is by design.

ZebrraSea took quite a runaround to initially get on the App Store because of its relationship with how you acquire Linux ISOs. After successfully getting it on the App Store, I want to avoid adding anything to ZebrraSea that would potentially get it revoked.

### "X" Won't Connect, Help!

The initial setup can either be incredibly easy or make you want to pull your hair out, I get that and that's what the community is here for! Please feel free to send a message to any of the listed methods to get support where either I or an awesome user in the community will surely come to help you out:

* [Discord](https://www.zebrrasea.app/discord)
* [Email](https://docs.zebrrasea.appmailto:hello@zebrrasea.app/)
* [Reddit](https://www.zebrrasea.app/reddit)

A few quick tips on common problems:

* `localhost` and `0.0.0.0` are internal hostnames that means "this computer". They cannot and should not be used as the host, but is commonly used because users mainly access the service from the computer running it. In order for ZebrraSea to connect, you must find the local IP of your computer (most common home networking configurations have it start with `192.168.0.x` or `192.168.1.x`)
* Ensure you match the right API key to the right service. I know this seems like an obvious thing, but you'd be surprised how easy it is to mix up 3-4 API keys when you're going back and forth copying and pasting!
* For the -arr services, ensure the binding address in the advanced general settings is not set to `127.0.0.1` or `localhost`, but instead set to either `0.0.0.0`, `*`, or the local IP for the computer/server.
* Similarly for the clients, ensure that the host is set to `0.0.0.0`, or the local IP.
* As noted in the host prompt, you must add either `http://` or `https://` before the IP or domain. ZebrraSea does not make any assumptions on the protocol to use (http or https).
* Do not use `3xx` redirecting webpages. This is not supported for POST and PUT requests (sending data back to the module) and can cause many headaches, so ideally you should be pointing directly to the module on your network.
* _(Windows Only)_: For a lot of software to correctly bind to your network, you need to ensure that you run the software as administrator. This is specifically very important for the -arrs, which will only bind to your host machine if you do not run it as administrator.

### How Can I Access My Services Remotely?

While this is outside of the scope of this project, I can try to point you in the right direction!

* **Reverse Proxy**: A reverse proxy allows you to open 1 or 2 ports on your network (typically 443 for SSL/https connections and 80 for http connections). Using a reverse proxy also allows you to attach a domain name to your IP and generate a free SSL certificate for https (hint, [LetsEncrypt](https://letsencrypt.org/)). Some common options for reverse proxies are [NGINX Proxy Manager](https://nginxproxymanager.com/), [Traefik](https://traefik.io/), [NGINX](https://nginx.org/), and [Apache](https://www.apache.org/).
* **VPN Tunnelling**: Another option is to create a VPN tunnel back to your home network, which would allow you to access your services as if you are on your home network. Tools like [WireGuard](https://www.wireguard.com/) and [OpenVPN](https://openvpn.net/) are perfect for this use case. This is technically the most secure method, but a bit less convenient than using a reverse proxy.
* **Direct Port Forwarding**: This method is _not recommended_, but another option is directly forward the ports of the services on your router and access the services via `<External IP>:<Port>`. The reason this is not recommended is because all of the traffic is sent unencrypted (you can use self-signed certificates, but this causes more headaches related to certificate authorities), and the more ports that are open on your network the less secure it is.

### I Want to Complain! Where Can I Complain?

Sorry that ZebrraSea is not meeting your expectations, feel free to post criticisms or complaints to any of the social platforms or directly [email me](https://docs.zebrrasea.appmailto:hello@zebrrasea.app/). I hope that I can remedy your complaints, all I ask is that you do not be abusive or disrespectful to myself or others in the community.

I also kindly request that before you submit a 1-star App Store/Play Store review that you consider contacting me directly with your complaints. 1-star reviews can really hurt a smaller application's rating since we do not typically get lots of reviews.
