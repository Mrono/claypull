#include <VirtualWire.h>

const int led_pin = 11;
const int receive_pin = 2;
const int transmit_en_pin = 3;
const int button_pin = 8;

void setup()
{
    vw_set_rx_pin(receive_pin);
    vw_setup(2000); 
    pinMode(led_pin, OUTPUT);
    pinMode(button_pin, INPUT_PULLUP);
}

void loop()
{
    if (digitalRead(button_pin) == LOW)
    {
        transmit();
    }
}

void transmit()
{
    char msg[7] = {1,8,2,3,5,9,4};
    int i;
    digitalWrite(led_pin, HIGH); // Flash a light to show transmitting
    for (i = 0; i < 4; i++)
    {
        vw_send((uint8_t *)msg, 7);
        vw_wait_tx(); // Wait until the whole message is gone
        delay(50);
    }

    digitalWrite(led_pin, LOW);
}