#include <VirtualWire.h>
#include <ServoTimer2.h>

const int piezo_pin = 2;
const int led_pin = 12;
const int receive_pin = 11;
const int servo_pin = 9;

long lastTrigger = 0;
ServoTimer2 myservo;

void setup()
{
    Serial.begin(9600);	// Debugging only
    Serial.println("setup");

    // Initialise the IO and ISR
    vw_set_rx_pin(receive_pin);
    vw_setup(2000);	 // Bits per sec

    vw_rx_start();       // Start the receiver PLL running

    pinMode(led_pin, OUTPUT);
    pinMode(piezo_pin, OUTPUT);

    myservo.attach(servo_pin);
    myservo.write(0);
    delay(750);
    myservo.detach();

    beep();
}

void loop()
{

	uint8_t buf[VW_MAX_MESSAGE_LEN];
	uint8_t buflen = VW_MAX_MESSAGE_LEN;

    if (vw_get_message(buf, &buflen)) // Non-blocking
    {
    	if (lastTrigger < millis())
    	{
    		int i;
    		byte matched = 0;
    		char msg[7] = {1,8,2,3,5,9,4};

	        digitalWrite(led_pin, HIGH); 

	        for (i = 0; i < buflen; i++)
	        {
	        	if (buf[i] == msg[i])
	        	{
	        		matched++;
	        	}
	        	Serial.print(buf[i], DEC);
	        }
	        if (matched == buflen)
	        {
	        	pull();
	        	Serial.println("Matched");
	        	lastTrigger = millis() + 5000;
	        }
	        else
	        {
	        	Serial.println("Not matched");
	        }
	        matched = 0;
	        digitalWrite(led_pin, LOW);
    	}
	}

	String content = "";
	char character;

	while(Serial.available()) {
	    character = Serial.read();
	    content.concat(character);
	}

	if (content == "1") {
	  	pull();
	}
}

void beep()
{
	digitalWrite(piezo_pin, HIGH);
	delay(50);
	digitalWrite(piezo_pin, LOW);
}

void pull()
{
	myservo.attach(servo_pin);
	myservo.write(2000);
	beep();
	delay(75);
	beep();
	delay(75);
	beep();
	delay(750);
	myservo.write(0);
	delay(750);
	myservo.detach();

}