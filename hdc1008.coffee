module.exports = (env) ->
  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'
  
  declapi = env.require 'decl-api'
  t = declapi.types

  class HDC1008Plugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
	
      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("HDC1008Sensor", {
        configDef: deviceConfigDef.HDC1008Sensor, 
        createCallback: (config, lastState) => 
          device = new HDC1008Sensor(config, lastState)
          return device
      })
	  
  class TemperatureSensor extends env.devices.Sensor

    attributes:
      temperature:
        description: "The measured temperature"
        type: t.number
        unit: '°C'
      humidity:
        description: "The actual degree of Humidity"
        type: "number"
        unit: '%'
       
    template: "temperature"	  
	  
  class HDC1008Sensor extends TemperatureSensor
    _temperature: null

    constructor: (@config, lastState) ->
      @id = @config.id
      @name = @config.name
      @_temperature = lastState?.temperature?.value
      @_humidity = lastState?.humidity?.value
      HDC1008 = require 'hdc1008'
      @sensor = new HDC1008({
        address: parseInt @config.address,
        device: @config.device,
        commandTemp: 0x00,
        lengthTemp: 2,
        commandHumi: 0x01,
        lengthHumi: 2
      });
      Promise.promisifyAll(@sensor)

      super()

      @requestValue()
      @intervalTimerId = setInterval( ( => @requestValue() ), @config.interval)

    destroy: () ->
      clearInterval @intervalTimerId if @intervalTimerId?
      super()

    requestValue: ->
      @sensor.readTemperature( (value) =>
      # if value isnt @_temperature
          @_temperature = value
          @emit 'temperature', value
      # else
       #  env.logger.debug("Sensor value (#{value}) did not change.")
    # ).catch( (error) =>
     #  env.logger.error(
      #    "Error reading HDC1008Sensor with address #{@config.address}: #{error.message}"
      # )
      #  env.logger.debug(error.stack)
      )

      @sensor.readHumidity( (value) =>
     # if value isnt @_humidity
          @_humidity = value
          @emit 'humidity', value
     # else
      #  env.logger.debug("Sensor value (#{value}) did not change.")
     # ).catch( (error) =>
      #  env.logger.error(
       #   "Error reading HDC1008Sensor with address #{@config.address}: #{error.message}"
      #  )
       # env.logger.debug(error.stack)


      )


    getTemperature: -> Promise.resolve(@_temperature)
    getHumidity: -> Promise.resolve(@_humidity)

  # Create a instance and return it to the framework
  myPlugin = new HDC1008Plugin
  return myPlugin

