# A Stable Tunneling Protocol With OpenConnect And Stunnel

```text
** you need two vps for Using the tunnels.
the first vps will be used by the client called mediator server (your mobile, laptop, or every device in which you can install OpenConnect or Cisco Any Connect) and the second one called host will be connect to the client server (you have to install OpenConnect in that)
```

## VPS

* you need 2 virtual private servers with low config as far as one core cpu and 1GB mem is enough for your config
* your servers need ubuntu 20.04 > version (20.04 is highly recommended)
* all the server ports should be opened

## Usage, First Config the Host server and then config the Mediator server

### Host server

1. (A) set a valid domain (x.x.com) to the ip of the host server ip (cloud flare is highly recommended ,but you have to turn the proxy option off)
2. you need check that domain is connected correctly (you can do it with simple ping command "ping x.x.com")
3. switch to the root user
4. clone the repo on the server
5. follow the steps

```bash
$> cd Host/
$> chmod +x host-install.sh
$> ./host-install.sh
```

```bash
$> Your Valid Domain : x.x.com
$> Your Email Address : my@email.com
```

```bash
$> How Many Connection Each User should Have (number between 1 and 8) ?  : 4
```

```bash
# you need to use chosen port in the mediator server in the next step
$> What is your approprate input port (hint: you will use this from mediator server) : 8888
```

```bash
# you can add a new user with running this script
$> chmod +x new_user.sh
$> ./new_user.sh
$> Username : user1
$> Password : myPassword
```

### Mediator server

1. (‌B) change the domain dns (x.x.com) to the ip of the mediator server ip (you have to turn the proxy option off or cdn)
2. you need check that domain is connected correctly (you can do it with simple ping command "ping x.x.com")
3. switch to the root user
4. clone the repo on the server
5. follow the steps

```bash
$> cd Mediator/
$> chmod +x mediator-install.sh
$> ./mediator-install.sh
```

```bash
$> What is your host server ip : my.host.ip.address
$> What is your host server input port (you have added this in host config) : 8888
```

### Usage

```you can use OpenConnect or Cisco Any Connect which are multi platform apps
host: x.x.com
username: user1
password: myPassword
```
