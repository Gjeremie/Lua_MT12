// 2024-09-20 - Arduino board "Nologo ESP32C3 Super Mini"
// before program press both button

//https://github.com/sidharthmohannair/Tutorial-ESP32-C3-Super-Mini

// https://github.com/AlfredoSystems/AlfredoCRSF/tree/main

// librairie running median :
// URL: https://github.com/RobTillaart/RunningMedian

//  AUTHOR: Rob Tillaart
//     URL: https://github.com/RobTillaart/INA228


#include <AlfredoCRSF.h> // lib csrf
#include <HardwareSerial.h>

#include <RunningMedian.h> // lib mediane mobile

#include "INA228.h" // lib ina228
INA228 INA(0x40);


// def des variable pour faire mediane des relevés
RunningMedian MOYtension = RunningMedian(100); // mediane glissante de 100 - tension
RunningMedian MOYcourant = RunningMedian(5); // moyenne glissante de 5 - Courant
RunningMedian MOYtemperature1 = RunningMedian(10); // mediane glissante de 10 - Temperature


// def  pin ESP32 pour   valeur entree Analogique
const int adcPin1 = 1;  // pour temperature

// pour frequenece verif valeur
unsigned long datedebut1 = 0;
unsigned long datedebut2 = 0;
unsigned long pulsedebut = 0;
unsigned long pulsecapa = 0;

// millivolt pour temperature
long millivolts1;

  // tension courant et temperature
  float tension = 4200;
  float courant = 0;
  
  // capacité
 float capa = 0;

#define PIN_RX 20   //  <<< 2  ER6  entree recepteur 
#define PIN_TX 21   //  <<< 3  ER6    entre recepteur serial CRFS  420000 bps

// Set up a new Serial object
HardwareSerial crsfSerial(1);
AlfredoCRSF crsf;


// =========================================== FONCTIONs ===================================  




// --------Fonction qui convertit la tension en température (pour une thermistance NTC de 10 kΩ) --------
float calculateTemperature(float millivolts) {
  const float VCC = 3300.0;      // Tension d'alimentation en mV
  const float R_FIXED = 10200.0; // res de 10.2 kΩ pull up
  const float BETA = 3950.0;     // constante beta de la thermistance
  const float T0 = 298.15;       // Température de référence 25°C en Kelvin
  const float R0 = 10000.0;      // Résistance de la thermistance à 25°C  (10k)

//  10kom NTC thermisotr from ground, pulled  10 kom to 3.3V

  // Calcul de la résistance de la thermistance
  float R_Thermistor = (millivolts * R_FIXED) / (VCC - millivolts);
  
  // Détermination de la température en Kelvin
  float temperatureK = 1.0 / ((1.0 / T0) + (1.0 / BETA) * log(R_Thermistor / R0));
  
  // Conversion en degrés Celsius
  float temperatureC = temperatureK - 273.15;
  
    
  // Appliquer des corrections : décalage et facteur de pente(y= ax+b) et retourner valeur  temperatureC
  return ( 1.0 * temperatureC + 0 );
}








//============================================   SETUP  ====================================  
void setup()
{

Wire.begin();

INA.begin();

INA.setMaxCurrentShunt(200, 0.00025); // shunt de 0.25 mOhm 



crsfSerial.begin(CRSF_BAUDRATE, SERIAL_8N1, PIN_RX, PIN_TX);
 
crsf.begin(crsfSerial);
  


datedebut1 = millis();
datedebut2 = millis();
pulsedebut = millis();
pulsecapa = millis();



 // Lecture des tensions en millivolts à partir de canaux ADC
millivolts1 = analogReadMilliVolts(adcPin1); // temp


  
  // Assigner tension courant et temperature
   tension = INA.getBusVoltage()*1000/6; // pour 6s
   courant = INA.getCurrent()*1000;
  
  float temperature1 = calculateTemperature(millivolts1);


MOYtension.add(tension); // ajoute derniere valeur relevé tension a mediane
MOYcourant.add(courant); // ajoute derniere valeur relevé tension a mediane
MOYtemperature1.add(temperature1); // ajoute derniere valeur relevé tension a mediane





}


//==============================================  LOOP   ============================================== 
void loop()
{


 // Must call crsf.update() in loop() to process data
 crsf.update();
  
// rq= avec ELRS en F1000 et telemetry ratio sur 1/8 : transmission toute les 8 ms




if( crsf.getChannel(11) > 1600) { // si ch11 sup a pos milieu (1500)
// crsf.getChannel(11);   // pour recup position channel 11 (en micro second)

capa = 0; // reset capa consommée

}




if ((millis()-datedebut1)>5) { // a faire tous les 5 ms

	  // Assigner tension courant 
	   tension = INA.getBusVoltage()*1000/6; // pour 6s
	   courant = INA.getCurrent()*1000;


	MOYtension.add(tension); // ajoute derniere valeur relevé tension a mediane
	MOYcourant.add(courant); // ajoute derniere valeur relevé tension a mediane



	datedebut1=millis();
}
  
  
  
  if ((millis()-pulsecapa)>25) { // a faire tous les 25 ms  (car 5ms * moyenne de 5)

	 // calcul capa consommée
capa = capa + MOYcourant.getAverage() /144000 ; // 0.025 = 25ms            * 0.025/3600 = /144000
	
	pulsecapa=millis();
}
  
  
  
  
 if ((millis()-datedebut2)>250) { // a faire tous les 250 ms

	 // Lecture des tensions en millivolts à partir canaux ADC
	   millivolts1 = analogReadMilliVolts(adcPin1); // temp
	  
	  // Appel fonction temperature
	  float temperature1 = calculateTemperature(millivolts1);
	 

	MOYtemperature1.add(temperature1); // ajoute derniere valeur relevé tension a mediane
	 
	  datedebut2=millis();
}
  




// appel fonction qui envoi au recepteur les valeurs telemetrie 
// envoie tension dans RXBt
// envoie courant dans Curr
// Envoie temperature dans Capa
// envoie valeur fixe dans pourcentage restant : 1
// rempli fonction envoie telemetry avec les medianes glissantes =
 //  sendRxBattery(MOYtension.getMedian(), MOYcourant.getMedian()/10.0, MOYtemperature1.getMedian(), 1);     //
  // tension en Mv     -    Courant en Centi A (4523 = 45230 mA)   -    Temperature  en degree 



// envoie packet RX BATTERY
if (millis()<30000) { // a faire au debut pendant 30 sec
	if ((millis()-pulsedebut)>5000) { // a faire tous les 5000 ms et pendant 300ms
	  sendRxBattery(5000, MOYcourant.getMedian()/10.0, MOYtemperature1.getMedian(), 1);  
	  
	  // envoie valeur avec tension fake a 5V 
	}
	else { // sinon envoie valeur normale
	  sendRxBattery(MOYtension.getMedian(), MOYcourant.getAverage()/10.0, MOYtemperature1.getMedian(), 1);  
	  
	  // tension en Mv     -    Courant en Centi A (4523 = 45230 mA)   -    Temperature  en degree 
	}
	if ((millis()-pulsedebut)>5200) { // reset 200 ms apres
	pulsedebut=millis();
	}
}

else { // apres 30 sec
	   sendRxBattery(MOYtension.getMedian(), MOYcourant.getAverage()/10.0, MOYtemperature1.getMedian(), 1);  
	  // tension en Mv     -    Courant en Centi A (4523 =   45 230 mA)   -    Temperature  en degree 
}





// envoie packet GPS / ALT

sendGps(1, 1, 541, 1, capa , 1);   
//   capacité en  mA/H   dans champ Alt


 
  




}
//===========================================   END LOOP   ===========================================



// Fonction pour envoie 4 valeur dans la telem tension
static void sendRxBattery(float voltage, float current, float capacity, float remaining)
{
  crsf_sensor_battery_t crsfBatt = { 0 };

  // Values are MSB first (BigEndian)
  crsfBatt.voltage = htobe16((uint16_t)(voltage));   // -  pour récup valeur identique faire x10 dans config sensor EDGETX (Ratio 255)  - MAX 65535
  crsfBatt.current = htobe16((uint16_t)(current));   //  -  pour récup valeur identique faire x10 dans config sensor EDGETX (Ratio 255)  - MAX 65535
  crsfBatt.capacity = htobe16((uint16_t)(capacity)) << 8;   // -  récup valeur identique faire x10 dans config sensor EDGETX (Ratio 255) - MAX 65535
  crsfBatt.remaining = (uint8_t)(remaining);                //  -  récup valeur identique   - MAX 100
  crsf.queuePacket(CRSF_SYNC_BYTE, CRSF_FRAMETYPE_BATTERY_SENSOR, &crsfBatt, sizeof(crsfBatt));
}




void sendGps(float latitude, float longitude, float groundspeed, float heading, float altitude, float satellites)
{
  crsf_sensor_gps_t crsfGps = { 0 };

  // Values are MSB first (BigEndian)
  crsfGps.latitude = htobe32((int32_t)(latitude*10000));  // -  pour récup valeur identique faire x1000 dans config sensor EDGETX (Ratio 25500)  - MAX 429946
  crsfGps.longitude = htobe32((int32_t)(longitude*10000));  // -  pour récup valeur identique faire x1000 dans config sensor EDGETX (Ratio 25500)  - MAX 429946
  crsfGps.groundspeed = htobe16((uint16_t)(groundspeed));  //  -  pour récup valeur identique faire x10 dans config sensor EDGETX (Ratio 255)  - MAX 65535
  crsfGps.heading = htobe16((int16_t)(heading)); //TODO: heading seems to not display in EdgeTX correctly, some kind of overflow error
  crsfGps.altitude = htobe16((uint16_t)(altitude + 1000.0)); // -  récup valeur identique  - MAX 64535
  crsfGps.satellites = (uint8_t)(satellites);   // -  récup valeur identique  - MAX 100
  crsf.queuePacket(CRSF_SYNC_BYTE, CRSF_FRAMETYPE_GPS, &crsfGps, sizeof(crsfGps));
}








