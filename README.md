# A Toit-powered Youtube subscriber/views counter
To keep track of your Youtube subscribers and video views, I put together this Youtube-tracker powered by Toit. It is currently set up to run only once, but it is of course easy to modify the code to run repeatedly, at a certain rate.

Remember to update the Toit code with your channel ID and API key
```
channelID := "YourYoutubeChannelID"
APIKey    := "YourYoutubeAPIKey"
```

# Prerequisites
This example requires Toit package toit-cert-roots and the driver for the HD44780 LCD controller. Install these Toit packages with 
```sh
toit pkg install github.com/toitware/toit-cert-roots
toit pkg install github.com/nilwes/HD44780
```

Visit pkt.toit.io for more packages

# Steps

## 1. Get the source code

Clone the repositories in a suitable directory:

``` sh
git clone https://github.com/nilwes/Toit-Youtubesubs
git clone https://github.com/toitlang/toit.git
```
You should now have two additional directories: `Toit-Youtubesubs/` and `toit/`.

## 2. Set up the build environment for Toit

Instructions can be found [here](https://github.com/toitlang/toit/blob/master/README.md)

## 3. Hook up the hardware

You need the following parts:
- ESP32 dev board
- 1602 LCD
- 10k potentiometer (or something like that)
 
Here's the Fritzing diagram of the whole hardware setup. 

<img width="1453" alt="Screenshot 2021-12-06 at 12 58 41" src="https://user-images.githubusercontent.com/58735688/144842199-d79eff08-967d-450c-bcb1-a8c106eefff9.png">


## 4. Run the demo

The next step is to build the ESP32 firmware for the `ytsubs.toit`. This is done from the `toit/` directory. You also need to specify your WiFi credentials so that the ESP32 can go online:

``` sh
make esp32 ESP32_ENTRY=/path/to/Toit-Youtubesubs/ytsubs.toit ESP32_WIFI_SSID=yourwifissid ESP32_WIFI_PASSWORD=yourwifipassword
```

Now it is time for the moment of truth: Flashing the binary to your ESP32!

Notice that the full `python esptool.py ...` command for flashing is shown at the end of the output of the make-command, and typically looks something like this:

``` sh
python /Users/nils/esp-idf/components/esptool_py/esptool/esptool.py --chip esp32 --port /dev/cu.usbserial-14330 --baud 921600 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect 0xd000 /Users/nils/toit/toit/build/esp32/ota_data_initial.bin 0x1000 /Users/nils/toit/toit/build/esp32/bootloader/bootloader.bin 0x10000 /Users/nils/toit/toit/build/esp32/toit.bin 0x8000 /Users/nils/toit/toit/build/esp32/partitions.bin
```
However, the `/dev/cu.usbserial-14330` port setting may have to be changed. To figure out which port to use, on macOS/Linux do 
```sh
ls -ltr /dev
```
to list the available ports. Look for something like `cu.usbserial-14330` on Mac. If you are running Linux the port is called something like `ttyUSB0`.

It is often useful to see the serial output from the device while it is running and you can use the `toit` command-line interface for that too:

``` sh
toit serial monitor
```
or you can stick to alternatives like `screen` on Linux/MacOS:

``` sh
screen /dev/cu.usbserial-14330 115200
```
where `115200` is your serial baud rate.

If you make changes to the code in `ytsubs.toit`, you need to build and run the demo again from step 4. Have fun!

# Picture or it didn't happen
![IMG_5395](https://user-images.githubusercontent.com/58735688/144844058-9d9e66ff-9cae-4f76-ad17-d2c774970d96.JPG)





