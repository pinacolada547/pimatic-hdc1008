# pimatic-bh1750
Pimatic support for the bh1750 light intensity sensor

### Drivers

I2C drivers need to be loaded in order to create the connection between the physical sensor and the rPI.
You can load them from the terminal (or from the /etc/modules script).

    sudo modprobe i2c_dev
    sudo modprobe i2c_bcm2708

You might also need to uncomment the following line in /boot/config.txt

	dtparam=i2c_arm=on

### Example config

Add the plugin to the plugin section:

```json
{ 
  "plugin": "bh1750"
}
```

Then add a sensor for your device to the devices section:

```json
{
  "id": "my-sensor",
  "name": "bh1750 example",
  "class": "BH1750Sensor",
  "device": "/dev/i2c-0",
  "address": "0x23",
  "interval": 10000
}
```