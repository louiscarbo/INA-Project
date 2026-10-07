#import "template/lib.typ": *
#import "@preview/callisto:0.3.0"

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#show: codly-init.with()
#codly(languages: codly-languages)

#show "petri net": "Petri net"

#import "@preview/tally:0.1.2": tally, todo-list
#show: tally.with(color: red)

#let authorsMatr = table(
  columns: (auto, auto),
  align: (left, left),
  stroke: none,
  [Mattis Negraszus], [PL73K2HKC3],
  [Elise], [abcd],
  [Louis], [abcd],
)

#show: hm-template.with(
  title: "Inteligencia Ambiental",
  subtitle: [MQTT on Shelly devices],
  doc-type: "",
  authors: authorsMatr,
  language: "en",
  toc-depth: 1,
  version: none,
  top-remark: "MQTT on Shelly devices",
  font: "Times New Roman",
)

#set heading(supplement: "Tarea")

#let leveling(..nums) = {
  let numArr = nums.pos()
  let depth = numArr.len()
  if (depth >= 3) {
    numArr = numArr.map(n => str(n))
    str(numArr.slice(2).join("."))
    "."
  }
}

// #set heading(numbering: leveling)

#set heading(numbering: "1.a.i.1.")

#show heading: it => block[
  // #if it.level == 3 {
  //   [
  //     // #it.depth #it.body
  //     // #it.fields()
  //   ]
  // }else{
  #it.body
  // }
]

= Tarea 4.1 - Screenshot

#figure(
  image("screenshot.png", width: 16cm),
  caption: "A screenshot showing MQTTExplorer graphing the data of the sensor and on the right, the MQTT-configuration of the H&T sensor.",
)

= Tarea 4.3 - Explanation

The developed system combines a Shelly Humidity & Temperature Wi-Fi sensor with a Telegram bot in order to issue automated warnings and allow remote readouts. Additionally, a temperature range can be set at which a fan is automatically turned on.

The bot is reachable under https://t.me/ina_temp_bot.

As the sensor is battery powered and Wi-Fi is ideally used with a constant connection to power, the sensor only wakes up about once every two hours to refresh its data to mqtt and fetch instructions from the shelly control panel.
The sensor is configured such that it publishes its data to the example.mosquitto.org server under the /upvina/humtemp topic.

Receiving the status updates is an application written in python. It is split into three parts: The businesslogic, the mqtt handler and the telegram bot handler.
The main function starts by setting up both the mqtt listener and the bot. The former also initializes with a status update of its own under /upvina/humtemp/bot/status to indicate its running status. It is ensured that the program does not shut down before a respective offline notification is sent to the same channel.

On the side of the telegram bot, there are multiple commands it accepts, listed in @t-commands.

#let frame(stroke) = (x, y) => (
  left: if x > 0 { 0pt } else { stroke },
  right: stroke,
  top: if y < 2 { stroke } else { 0pt },
  bottom: stroke,
)

#set table(
  fill: (_, y) => if calc.odd(y) { rgb("EAF2F5") },
  stroke: frame(1pt + rgb("21222C")),
)

#figure(
  table(
    columns: 2,
    table.header[*Command*][*Description*],
    [/get_temp], [Returns the current temperature],
    [/get_hum], [Returns the current humidity],
    [/get], [Returns both the current humidity and temperature],
    [/set_alarm], [Set a temperature alarm, at which a notification will automatically be sent.],
    [/get_alarm], [Retrieve the set alarm temperature and status.],
    [/enable_alarm], [Enables the alarm notifications.],
    [/disable_alarm], [Disables the alarm notifications.],
    [/status], [Returns the time of the last known update to the data.],
    [/set_fan_range], [Set a range of temperatures, at which the fan is turned on.],
    [/get_fan_range], [Returns the current temperature range for the fan.],
    [/get_fan_state], [Returns the current state of the fan.]
  ),
  caption: [The available commands of the telegram bot, including their descriptions.],
)<t-commands>

The /get command shows the current temperature and humidity, and the /status command additionally includes alarm information and the time of the last update.

== Temperature Alarm

It is possible for each user to set a personalized alarm temperature. If the newest measurement is higher, a message is automatically sent to the respective users and their alarm is turned off.
Each user can set their alarm temperature using /set_alarm. This command expects a number, which is interpreted as the desired temperature in degrees celsius.
The personal alarm temperature can be retreived using /get_alarm.
For the alarm to trigger, is must be enabled using /enable_alarm. If no alarm temperature is set, an error is returned.
Conversly, /disable_alarm disables the notification.

== Fan control

The program also allows the automated control of a simulated fan. We think of this fan to be attached to an outlet which is controlled by a Shelly wall outlet.
For testing and development purposes, an already installed ShellyMini Gen3 (although in reality it is attached to lights).
It accepts commands to upvina/shellyMiniGen3/command/switch:0 with payloads "on" or "off".

The command /set_fan_range requires two numbers as paramers, otherwise a respective error message with syntax clarification is returned. The first number sets the lower bound and the second number the upper bound on the temperature range at which the fan is automatically turned on. If the temperature is outside the range, the fan is turned off.

Using /get_fan_range returns the currently set range and /get_fan_state additionally calculates the current on or off position with regards to the last known temperature.