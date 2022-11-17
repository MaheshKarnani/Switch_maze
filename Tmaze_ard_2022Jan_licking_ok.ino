#include<Servo.h>
Servo servo1;     // Servo 1 = door1
#include<Servo.h>
Servo servo2;     // Servo 2 = door2
#include<Servo.h>
Servo servo3;     // Servo 3 = door3
#include<Servo.h>
Servo servo4;     // Servo 4 = running-wheel brake
#include<Servo.h>
Servo servo5;     // Servo 5 = food pod
#include <CapacitiveSensor.h>
CapacitiveSensor   cs_30_31 = CapacitiveSensor(30,31);       // 10M resistor between pins 30 & 31, pin 31 is sensor pin, 
                                                        //add a wire and or foil if desired 
//Constants
const int slowness = 3;   //slowness factor, ms wait between 1deg movements, change to set speed
//beam breaks
const int pResistor1 = A0;//BB1
const int pResistor2 = A1;//BB2
const int pResistor3 = A2;//BB3 choice running wheel
const int pResistor4 = A3;//BB4 choice food pod
const int pResistor5 = A4;//BB5 return safety
//servo control
const int servoPin1 = 2;// door servos 1-3
const int servoPin2 = 3;
const int servoPin3 = 4;
const int servoPin4 = 5;// brake servo in running wheel
const int servoPin5 = 6;// surprise pod servo
//outputs to Pi
const int ard_pi_1 = 38;//reports BB1low to Pi
const int ard_pi_2 = 39;//reports BB2low to Pi
const int ard_pi_3 = 40;//reports BB3low to Pi
const int ard_pi_4 = 41;//reports BB4low to Pi
const int ard_pi_5 = 42;//reports BB5high to Pi
const int ard_pi_lick = 43;//reports capacitive sensor to Pi
const int lick_led = 44;//reports capacitive sensor to user
//door angles
const int CLOSE_DOOR1 = 150;//150;//Angle of 150 degrees -> door is closed
const int OPEN_DOOR1 = 47;//Angle of 47 degrees -> door is opened
const int HELP_DOOR1 = 60;//help on close so it does not get stuck
const int CLOSE_DOOR2 = 164;//155;//Angle of 155 degrees -> door is closed
const int OPEN_DOOR2 = 30;// 40
const int CLOSE_DOOR3 = 157;//Angle of 159 degrees -> middle passage is closed
const int OPEN_DOOR3 = 89;// 87
const int RELEASE_WHEEL = 80;//Angle of 39 degrees -> WHEEL is free
const int BRAKE_WHEEL = 112;//20 CLAMPED
const int SHOW_FOOD = 140;//Angle of 170 degrees -> FOOD IN CENTER
const int HIDE_FOOD = 123;//123 HIDDEN
const int FOOD_SPEED = 20;//delay for moving 1deg; higher is slower
//motor inputs from Pi
const int pi_ard_1 = 22;//open door1
const int pi_ard_2 = 23;//open door2
const int pi_ard_3 = 24;//open door3
const int pi_ard_4ow = 25;//open wheel
const int pi_ard_5p = 26;//present pod

//Variables
int photo_value1;//Store value from photoresistor (0-1023)
int INIT_READ1;//Store initial value from photoresistor    
int photo_value2;//Store value from photoresistor (0-1023)
int INIT_READ2;
int photo_value3;//Store value from photoresistor (0-1023)
int INIT_READ3;
int photo_value4;//Store value from photoresistor (0-1023)
int INIT_READ4;
int photo_value5;//Store value from photoresistor (0-1023)
int INIT_READ5;
int pos1_current = OPEN_DOOR1; //initial position variables for servos
int pos1_target = OPEN_DOOR1;
int pos2_current = OPEN_DOOR2; //initial position variables for servos
int pos2_target = OPEN_DOOR2;
int pos3_current = OPEN_DOOR3; //initial position variables for servos
int pos3_target = OPEN_DOOR3;
int pos4_current = RELEASE_WHEEL; //initial position variables for servos
int pos4_target = RELEASE_WHEEL;
int pos5_current = SHOW_FOOD; //initial position variables for servos
int pos5_target = SHOW_FOOD;
long start = millis();
//Capacitive sensor
int cs_thresh;//look at serial monitor during testing to find a value
int var;
int cs1;
  
void setup()
{
  cs_30_31.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
  Serial.begin(9600);//setup serial
  pinMode(pResistor1, INPUT);//Set pResistor - A0 pin as an input 
  pinMode(pResistor2, INPUT);
  pinMode(pResistor3, INPUT);
  pinMode(pResistor4, INPUT);
  pinMode(pResistor5, INPUT);
  pinMode(ard_pi_1, OUTPUT);//output reports to Pi
  pinMode(ard_pi_2, OUTPUT);  
  pinMode(ard_pi_3, OUTPUT); 
  pinMode(ard_pi_4, OUTPUT); 
  pinMode(ard_pi_5, OUTPUT); 
  pinMode(ard_pi_lick, OUTPUT); 
  pinMode(lick_led, OUTPUT); 
  pinMode(pi_ard_1, INPUT);//input commands from Pi
  pinMode(pi_ard_2, INPUT);
  pinMode(pi_ard_3, INPUT);

  servo1.attach(servoPin1);
  servo1.write(OPEN_DOOR1);
  delay(1000);
  INIT_READ5 = analogRead(pResistor5);//calibrate top side detector when door1 open
  delay(200);
  servo1.write(CLOSE_DOOR1); 
  delay(100);
//  servo1.write(HELP_DOOR1);//unstick door1
//  delay(100);
//  servo1.write(CLOSE_DOOR1);//close
//  delay(100);
  servo2.attach(servoPin2);
  servo2.write(OPEN_DOOR2);
  delay(100);
  servo2.write(CLOSE_DOOR2);
  delay(100);
  servo3.attach(servoPin3);
  servo3.write(OPEN_DOOR3);
  delay(500);
  servo3.write(CLOSE_DOOR3);
  servo4.attach(servoPin4);
  servo4.write(BRAKE_WHEEL);
  delay(1000);
  servo4.write(RELEASE_WHEEL);
  delay(500);
  servo5.attach(servoPin5);
  servo5.write(SHOW_FOOD);
  delay(100);
  servo5.write(HIDE_FOOD);
  delay(100);
  
  digitalWrite(ard_pi_1, LOW);//communication to Pi
  digitalWrite(ard_pi_2, LOW);
  digitalWrite(ard_pi_3, LOW);
  digitalWrite(ard_pi_4, LOW);
  digitalWrite(ard_pi_5, LOW);
  digitalWrite(ard_pi_lick, LOW);

  INIT_READ1 = analogRead(pResistor1); // calibrate beam-breaks
  INIT_READ2 = analogRead(pResistor2);
  INIT_READ3 = analogRead(pResistor3);
  INIT_READ4 = analogRead(pResistor4);
  //collect lick sensor bsl
  delay(500);
  var = 0;
  cs_thresh=0;
  while (var < 5) 
  {
    cs_thresh =  cs_thresh+cs_30_31.capacitiveSensor(30);
    var++;
  }
  cs_thresh=(cs_thresh/5)+200;
  delay(100);
  //Serial.print("cs_threshold   ");  //show value for trouble shooting if serial monitor is on
  //Serial.println(cs_thresh);
  
  //cs_30_31.capacitiveSensor(30);
  
  Serial.print("INIT_READ1 ");  //show beam break values for trouble shooting if serial monitor is on
  Serial.println(INIT_READ1);  
  Serial.print("INIT_READ2 ");  
  Serial.println(INIT_READ2);  
  Serial.print("INIT_READ3 ");  
  Serial.println(INIT_READ3);  
  Serial.print("INIT_READ4 ");  
  Serial.println(INIT_READ4);  
  Serial.print("INIT_READ5 ");  
  Serial.println(INIT_READ5);


}

void loop()
{
    //Serial.print(millis() - start); 
    start = millis();
    var = 0;
    cs1=0;
    while (var < 2) 
    {
      cs1 =  cs1+cs_30_31.capacitiveSensor(30);
      var++;
    }
    cs1 = (cs1/2);
    //Serial.print("cs1   ");  //show value for trouble shooting if serial monitor is on
    //Serial.println(cs1);
    //Serial.print("\t");                    // tab character for debug windown spacing
    //Serial.println(cs1); 
    photo_value1 = analogRead(pResistor1); //read beam breaks
    photo_value2 = analogRead(pResistor2);
    photo_value3 = analogRead(pResistor3);
    photo_value4 = analogRead(pResistor4);
    photo_value5 = analogRead(pResistor5);
    // Serial.print("photo_value1 ");  
    // Serial.print("photo_value1 ");  
    // Serial.println(photo_value1);  
    // Serial.print("photo_value2 ");  
    // Serial.println(photo_value2);  
    // Serial.print("photo_value3 ");  
    // Serial.println(photo_value3);  
    // Serial.print("photo_value4 ");  
    // Serial.println(photo_value4);  
    // Serial.print("photo_value5 ");  
    // Serial.println(photo_value5);  

    //output to Pi
    if (photo_value1<INIT_READ1*0.7) //BB1
    {
        digitalWrite(ard_pi_1, HIGH);
    }  
    else
    {
        digitalWrite(ard_pi_1, LOW);
    }

    if (photo_value2<INIT_READ2*0.7) //BB2
    {
        digitalWrite(ard_pi_2, HIGH);
    }  
    else
    {
        digitalWrite(ard_pi_2, LOW);
    }

    if (photo_value3<INIT_READ3*0.7) //BB3
    {
        digitalWrite(ard_pi_3, HIGH);
    }  
    else
    {
        digitalWrite(ard_pi_3, LOW);
    }

    if (photo_value4<INIT_READ4*0.7) //BB4
    {
        digitalWrite(ard_pi_4, HIGH);
    }  
    else
    {
        digitalWrite(ard_pi_4, LOW);
    }

    if (photo_value5<INIT_READ5*0.8) //BB5safety
    {
        digitalWrite(ard_pi_5, LOW);
    }  
    else
    {
        digitalWrite(ard_pi_5, HIGH);
    }

    if (cs1<cs_thresh) //capacitive sensor
    {
        digitalWrite(ard_pi_lick, LOW);
        digitalWrite(lick_led, LOW);
    }  
    else
    {
        digitalWrite(ard_pi_lick, HIGH);
        digitalWrite(lick_led, HIGH);
    }

    //new servo if loops
    if (pos1_current<pos1_target) //SERVO 1
    {
        pos1_current=pos1_current+1;
        servo1.write(pos1_current);     
        delay(slowness); 
    }
    if (pos1_current>pos1_target)
    {
        pos1_current=pos1_current-1;
        servo1.write(pos1_current);     
        delay(slowness); 
    }

    if (pos2_current<pos2_target) //SERVO 2
    {
        pos2_current=pos2_current+1;
        servo2.write(pos2_current);     
        delay(slowness); 
    }
    if (pos2_current>pos2_target)
    {
        pos2_current=pos2_current-1;
        servo2.write(pos2_current);     
        delay(slowness); 
    }

    if (pos3_current<pos3_target) //SERVO 3
    {
        pos3_current=pos3_current+1;
        servo3.write(pos3_current);     
        delay(slowness); 
    }
    if (pos3_current>pos3_target)
    {
        pos3_current=pos3_current-1;
        servo3.write(pos3_current);     
        delay(slowness); 
    }

    if (pos4_current<pos4_target) //SERVO 4
    {
        pos4_current=pos4_current+1;
        servo4.write(pos4_current);     
        delay(slowness); 
    }
    if (pos4_current>pos4_target)
    {
        pos4_current=pos4_current-1;
        servo4.write(pos4_current);     
        delay(slowness); 
    }

    if (pos5_current<pos5_target) //SERVO 5
    {
        pos5_current=pos5_current+1;
        servo5.write(pos5_current);     
        delay(slowness); 
    }
    if (pos5_current>pos5_target)
    {
        pos5_current=pos5_current-1;
        servo5.write(pos5_current);     
        delay(slowness); 
    }

    //target commands
    //SERVO 1
    if ((digitalRead(pi_ard_1) == HIGH)) 
    {
        pos1_target=OPEN_DOOR1;
    }
    else 
    {
        pos1_target=CLOSE_DOOR1;
    }
    //SERVO 2
    if ((digitalRead(pi_ard_2) == HIGH)) 
    {
        pos2_target=OPEN_DOOR2;
    }
    else 
    {
        pos2_target=CLOSE_DOOR2;
    }
    //SERVO 3
    if ((digitalRead(pi_ard_3) == HIGH)) 
    {
        pos3_target=OPEN_DOOR3;
    }
    else 
    {
        pos3_target=CLOSE_DOOR3;
    }
    //SERVO 4
    if ((digitalRead(pi_ard_4ow) == HIGH)) 
    {
        pos4_target=RELEASE_WHEEL;
    }
    else 
    {
        pos4_target=BRAKE_WHEEL;
    }
    //SERVO 5
    if ((digitalRead(pi_ard_5p) == HIGH)) 
    {
        pos5_target=HIDE_FOOD;
    }
    else 
    {
        pos5_target=HIDE_FOOD;
    }

}//void loop end
