
# CoFight-19 iOS client

When a patient is tested positive for Covid-19 authorities need to track recent contact the patient made to warn or quarantine those contacts. CoFight-19 is a volunteering effort to create a complete (basic) stack for setting up a system for tracing contacts.

## How it works (tl;dr)

Each user registers the device phone number and gets back a unique user ID.

Using only Bluetooth, CoFight identifies nearby phones that have the app installed. It records the IDs that come in close proximity and a timestamp. 

When there's a confirmed case, the patient can upload all the data to a central server. Authorities then can then notify the known contacts, thus stopping the spread of the virus.

## Technical

Each device registers a BLE server and client. We define a Service UUID and a Characteristic UUID. We advertise the Service UUID and devices are scanning for that UUID. When a device is found, they connect and read the characteristic that contains the user ID. 

On iOS there is a limitation from Apple: iOS devices can't advertise their Service UUID when in the background so it's recommended to keep the app in the foreground (eg. when the user is expected to be in a crowded space) and enable the in-app battery save mode.

Everything is stored on device's keychain for security reasons. Data older than 21 days are removed on app initialization.

## Localisation
The app is avaible in English and Greek. If you need to support another language, just add the localisation, copy the **English** localisation and then translate it.

## Caveats

* BLE can record up to 10 meters. But closed contact for the virus spread is considered up to 4 meters.

## Screenshots
### Welcome
![Welcome](https://i.imgur.com/MguIvsq.png)

### Enter your telephone number
![Enter your telephone number](https://i.imgur.com/bc2sqXM.png)

### Verify your telephone number
![Verify your telephone number](https://i.imgur.com/CG5jd6V.png)

### Main View
![Main View](https://i.imgur.com/VR1267c.png)

### Battery save View
![Battery save View](https://i.imgur.com/I7ppgKr.png)