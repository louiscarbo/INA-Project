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
  [Mattis Negraszus],[PL73K2HKC3],
  [Elise],[abcd],
  [Louis],[abcd],
)

#show: hm-template.with(
  title: "Inteligencia Ambiental",
  subtitle: [MQTT on Shelly devices],
  doc-type: "",
  authors: authorsMatr,
  language: "en",
  toc-depth: 1,
  version: none,
  top-remark:"Ejercicio 1",
  font: "Times New Roman"
)

#set heading(supplement: "Tarea")

#let leveling(..nums) = {
  let numArr = nums.pos()
  let depth = numArr.len()
  if (depth >= 3){
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
  image("screenshot.png", width:16cm),
  caption: "A screenshot showing MQTTExplorer graphing the data of the sensor and on the right, the MQTT-configuration of the H&T sensor."
)

= Tarea 4.3 - Explanation