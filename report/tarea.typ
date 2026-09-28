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
)

#show: hm-template.with(
  title: "Automation and Robotics",
  subtitle: [Exercicio 1\ INTRODUCCIÓN A LA ROBÓTICA],
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

// EJERCICIO DE EVALUACIÓN DE CLASE INVERSA
// INTRODUCCIÓN A LA ROBÓTICA
// Trabajo obligatorio de evaluación:
// Visualiza y analiza el vídeo “Ej 1. KUKA” disponible en PoliformaT.
// Escribe en un pequeño informe los siguientes puntos tal como se hizo en clase con casos
// similares:
// • Proceso
// • Tipo de Robots
// • Utillaje para cada robot
// • Sensores que se usan en la aplicación.
// Además, contesta a los dos siguientes apartados:
// • Si la altura de la pieza pudiera variar siendo la misma pieza, ¿qué sensor o sensores
// usarías, de qué tipo y dónde lo/los colocarías? Justifica la respuesta
// • Si el tamaño de la pieza (largo y ancho) pudiera variar, siendo la misma pieza escalada a
// otro tamaño, ¿qué sensor o sensores usarías, de qué tipo y dónde lo/los colocarías?
// Justifica la respuesta
// • Busca un modelo en el catálogo de KUKA que pudiera realizar estas operaciones y
// razona la respuesta.
// Ampliaciones voluntarias:
// a) Como se observa claramente en el vídeo anterior, la célula robotizada está vallada por
// motivos de seguridad para aislar los robots de operarios de la zona de trabajo, según exige la
// ley. Para evitar el vallado, se pueden usar dispositivos que creen una pared virtual para
// reconocer si una persona u objeto corta el haz por entrar en la zona de trabajo.
// Realiza una búsqueda en la red de los siguientes términos:
// • “SICK barrera óptica para célula robot”
// • “cortina fotoeléctrica de seguridad robot”
// • O abre el siguiente enlace
// Comenta en el informe posibles soluciones que hayas encontrado para evitar el vallado.
// b) Mira los vídeos titulados “Ej 2. ABB” y “Ej 3. ABB” disponibles en PoliformaT. Comenta en el
// informe cómo crees que funciona este sistema y cuándo crees que es utilizable.
// c) Mira el vídeo “Ej 4. UR” disponible en PoliformaT. Como ves, esta celda robotizada no tiene
// vallado, permitiendo que compartan zona de trabajo un robot y un operario. Este tipo de
// robots, denominados robots colaborativo (COBOTs), está implantándose en muchas
// aplicaciones últimamente. Busca en internet qué es un COBOT y qué condiciones debe cumplir
// un robot para poder usarse sin vallado. Comenta ambos aspectos en el informe.
// 1

= Informe

=== Process

The video shows the process of glue application to a part.
A conveyor belt moves multiple fixtures, which each hold one part. The fixtures stop for each processing step.

The first one is performed by a large robot arm with a spray applicator for its tool.
Presumably, it is spraying an activator, cleaner or primer as a preparation for the second step.
Audio cues indicate that compressed air is used to apply the substance.

A second robot with the same hardware, except for a different tool, is applying a thick substance,
presumably glue, following a very similar toolpath. Additionally, it wipes the nozzle to remove excess glue after each pass.
The assumption that a simple pump is used for glue dispensing would support the hypothesis of the spray being an activator for the glue. Otherwise, the glue could become inflexible within the pump, ceasing further operations.

In a third step, a human places another transparent plastic part on top.
The connected parts touch at the perimeter, where the spray and glue were placed beforehand.

=== Robot specifications

The robots are located in a protective cage and are able to move on 5 rotational axes.
The first one is used to rotate the entire robot around its vertical axis.
Next in line are two further axes, oriented the same and both orthogonal to the first one.
They allow movement of the toolhead on a vertical plane. 
The last two axes are used to precisely rotate and position the tool.
It should be noted that all motors, except for one, are located directly at the respective joint without any gearboxes or other types of power transmission visible.
Only one motor for the precise toolhead positioning is placed on the other side of the arm at which the joint is found.
This is likely done to equalize the weight on the arm around the third axis, reducing load and power consumption.

While robot power and control cables are routed along the arm itself,
the tool control wires and substance supply pipe is routed over the top. 

=== Sensors

As no other locating sensors or systems are visible, it can be expected that
the toolhead positioning is entirely performed through rotational encoders at the motors.
The parts position is given by its placement on its fixture which in turn is presumably located
by an external light sensitive diode or laser barrier#footnote[Example: https://my.kuka.com/s/product/forktype-photoelectric-barrier/01t58000003cPefAAE] (photocell). Its obfuscation from a fixed light source by the fixture indicates the fixtures position.

= Preguntas

=== Si la altura de la pieza pudiera variar siendo la misma pieza, ¿qué sensor o sensores usarías, de qué tipo y dónde lo/los colocarías?

I would suggest using a fixed laser based distance sensor placed above the conveyor belt such that is able to scan all parts passing below.
This way, no time positioning the robot for measuring is wasted and it can continue to work uninterrupted.
A laser based distance measurement is precise and fast, perfectly integrating into the existing workflow.
As they are placed above the workpiece, for which the position (but not the height) is known, the missing variable can be measured within
the time it takes for the tool to move into position, which is of course adapted based on the measurement.

=== Si el tamaño de la pieza (largo y ancho) pudiera variar, siendo la misma pieza escalada a otro tamaño, ¿qué sensor o sensores usarías, de qué tipo y dónde lo/los colocarías?

If possible, I would design the fixture such that one corner is always fixed with one side being oriented along a known direction (wall).
This way, it is possible to use two fixed distance sensors horizontal and orthogonal to each other to determine width and length as in the previous question, just along a different axis.

However, this can be difficult to implement for complicated shapes.
In this case, using a camera, such as the KMP1500#footnote[Source: https://my.kuka.com/s/product/positioning-camera-front-kmp1500/01t1i000000AQSIAA4] above the parts might be a more suitable option. With the right image processing, it can be used to determine part sizes and positioning within multiple milliseconds. While it is limited by its resolution, in the given scenario the required precision is beyond the millimeter range and as such do not need high precision measurement devices.

=== Busca un modelo en el catálogo de KUKA que pudiera realizar estas operaciones

For the first case I would recommend the DT20-P214BS03#footnote[
    #box[
    Datasheet: https://www.sick.com/media/pdf/6/46/046/dataSheet_DT20-P214BS03_1051547_en.pdf \
     Catalogue: https://my.kuka.com/s/product/distance-sensor-dt20p214bs03/01t58000006AzxJAAS]]
as it allows for precise distance measurement from 10 to 60 centimeters with a high sampling frequency. 
This allows for the robot to continue its work without having to stop for measurements.

In the second case, it can also be used. However, additional movements of the robot might be required
to get the desired measurements.

= Voluntarias

== a) 
// Como se observa claramente en el vídeo anterior, la célula robotizada está vallada por
// motivos de seguridad para aislar los robots de operarios de la zona de trabajo, según exige la
// ley. Para evitar el vallado, se pueden usar dispositivos que creen una pared virtual para
// reconocer si una persona u objeto corta el haz por entrar en la zona de trabajo.
// Realiza una búsqueda en la red de los siguientes términos:
// - "SICK barrera óptica para célula robot"
// - "cortina fotoeléctrica de seguridad robot"
// - O abre el siguiente #link("https://www.google.es/search?tbm=isch&tbs=rimg%3ACQ77VRxIM1KDIji0URW5UEo56A1nDciXKnffpAehkSGciokBZ8znpEaCEqk6MufUkdZVBjjdfQAu90GCqlDEe0bRBCoSCbRRFblQSjnoES8WscnFmUP1KhIJDWcNyJcqd98R1X0rQwKPYQ0qEgmkB6GRIZyKiRG3GFZhg34J4CoSCQFnzOekRoISEaMQwBqh9_11-KhIJqToy59SR1lURT5WOPUxCu5EqEgkGON19AC73QRG0qLZdMddlHioSCYKqUMR7RtEEEX0wtM9jPIM3&q=sick%20barrera%20%C3%B3ptica%20para%20c%C3%A9lula%20robot&bih=881&biw=1236&ved=0ahUKEwiPv_-W04nPAhVGtxQKHRJCAr4Q9C8ICQ&dpr=1")[enlace]
// Comenta en el informe posibles soluciones que hayas encontrado para evitar el vallado.

Light barriers are commonly used to create virtual walls around robot cells. They are composed of an array of light beams which are interrupted when an object enters the area. This interruption can be detected and used to  trigger a safety response from the machine, i.e. stopping all movement. A light curtain allows for human operators to work on the same parts as the robot without the need to open doors every time part access is needed.

#figure(
  image("figures/light curtain.jpg", width: 9cm),
  caption: [Example layout for a light curtain around a robot cell.#footnote[Source: https://www.pilz.com/es-ES/products/applications/electrosensitive-protective-equipment]]
)


== b) 
// Mira los vídeos titulados “Ej 2. ABB” y “Ej 3. ABB” disponibles en PoliformaT. Comenta en el
// informe cómo crees que funciona este sistema y cuándo crees que es utilizable.

SafeMove is a safety system based on a 2D laser scanner.
The demo shows the system to be based on different defined zones for which corresponding actions are performed if an obstruction, typically a human, enters them. If the human approaches the robot, it is programmed to slow down its current action and stop it completely upon further reduced distance. Additionally, if the approach is too rapid, an emergency stop is executed, ensuring human safety.

The system can be used in all areas without physical fencing and even allows for direct interaction between the robot and a human without safety compromises. However, fences still allow high robot density on the shop floor without repeated slowdowns by humans walking by or performing inspection.

== c) 
// Mira el vídeo “Ej 4. UR” disponible en PoliformaT. Como ves, esta celda robotizada no tiene
// vallado, permitiendo que compartan zona de trabajo un robot y un operario. Este tipo de
// robots, denominados robots colaborativo (COBOTs), está implantándose en muchas
// aplicaciones últimamente. 
// Busca en internet 
// - qué es un COBOT y 
// - qué condiciones debe cumplir un robot para poder usarse sin vallado. 
// Comenta ambos aspectos en el informe.

Collaborative robots, or COBOTs are designed to work alongside or in direct 
collaboration with humans without the need for virtual or physical fencing.
It should be noted, that it must avoid harming humans as an effect of its movements.
This includes both its end effector and attached work pieces.
#footnote[
  #box[
    Source: https://www.dguv.de/ifa/fachinfos/kollaborierende-roboter/index.jsp
  ]
]
The required safety is achieved, for example, by including sensors in the robot to
detect touches  or collisions with humans. This way, movements can be stopped. 
This of course leads to a slow maximum movement speed in comparison to the
motors capabilities.
#footnote[
  #box[
    Source: https://en.wikipedia.org/wiki/Cobot 
    ]
]

The ability to work alongside humans makes COBOTS a useful tool, allowing for new types of robots,
such as robots on a moving platform. The downside of lower speed requirement however
keeps non-COBOTS from deprecation, as a fenced-in version does need to adhere to speed limits.

