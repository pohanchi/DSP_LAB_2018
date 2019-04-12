int pot = A0;
int val = 0;
int start_time;
int now_time;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(pot,INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:

  start_time = micros();

  val = analogRead(pot);    //read analog input

  //val = map(val,0,1023,0,255);    //mapping 
  //Serial.println(sizeof(val));
  //Serial.println(val,BIN);
  Serial.println(val,DEC);
  //Serial.println(size_t(Serial.print(val,DEC)),DEC);     //print on Matlab  
  
  now_time = micros();
  
  while(now_time-start_time<4545.45){    //sample rate  
    now_time = micros();
    //Serial.println(now_time,DEC);
  }
   
}
