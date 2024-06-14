#include <WiFi.h>
#include <HTTPClient.h>

int pin = 21;

const char* ssid = "Dz";
const char* password = "12345678";
const char* serverAddress = "http://192.168.43.66:5000/sensor/suhu";

void setup() {
  Serial.begin(115200);
  delay(1000);
  Serial.println("Connecting to WiFi...");
  
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  
  Serial.println("Connected to WiFi");
}

void loop() {
  delay(2000);
  int g = analogRead(pin);
  Serial.println(g);

  sendToServer(g);
}

void sendToServer(int g) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(serverAddress);
    int httpResponseCode = http.POST(String(g));

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println("Data sent to server!");
      Serial.println(response);
    } else {
      Serial.print("Error on sending POST: ");
      Serial.println(httpResponseCode);
    }

    http.end();
  } else {
    Serial.println("WiFi Disconnected");
  }
}



