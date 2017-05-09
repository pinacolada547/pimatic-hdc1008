module.exports = {
  title: "pimatic-hdc1008 device config schemas"
  HDC1008Sensor: {
    title: "HDC1008Sensor config options"
    type: "object"
    extensions: ["xLink"]
    properties:
      device:
        description: "device file to use, for example /dev/i2c-0"
        type: "string"
      address:
        description: "the address of the sensor"
        type: "string"
      interval:
        interval: "Interval in ms so read the sensor"
        type: "integer"
        default: 10000
  }
}
