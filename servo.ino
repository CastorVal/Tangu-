
// Incluímos la librería para poder controlar el servo
#include <Servo.h>
 bool Ganar = false;
 bool cicle =true;
 int val;
 
// Declaramos la variable para controlar el servo
Servo servoMotor;
 
void setup() {
  // Iniciamos el monitor serie para mostrar el resultado
  Serial.begin(9600);
 
  // Iniciamos el servo para que empiece a trabajar con el pin 9
  servoMotor.attach(9);
  
}
 
void loop() {
  if(Serial.available())
  {
    val= Serial.read();
    Serial.println(val);
    if(val == 1){
      Ganar = true;
      }

      if(Ganar==true)
        {
          if (cicle==true){
          Serial.print("Ganar");
        // Desplazamos a la posición 0º
        servoMotor.write(90);
        // Esperamos 1 segundo
        delay(1000);
  
        // Desplazamos a la posición 90º
        servoMotor.write(0);
        // Esperamos 1 segundo
        delay(1000);
  
        // Desplazamos a la posición 0º
        servoMotor.write(90);
        // Esperamos 1 segundo
        cicle=false;
          }
          
        }

        

      
   }
  
  


  }

 

