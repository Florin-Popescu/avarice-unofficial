# AVaRICE
GDB debug server for AVR microcontrollers

## Changes from official repo
- Added support for following devices:
    - ATmega324PB
    - ATmega3208, ATmega4808, ATmega4809
    - ATmega16a4u
    - ATtiny402, ATtiny412, ATtiny814, ATtiny3217
- Added support for UPDI. This is very similar to PDI but:
	- communication is done over one bidirectional wire
	- initialization sequence is different, needs a separate device descriptor type
	- different access requirements for some memory regions (e.g. flash cannot be read byte by byte)
- Updated device descriptor generator to Python3 syntax

## Supporting new stuff
This is a rough guide since it only documents changes already performed. So far new devices and debugger protocols are still fairly compatibile with existing ones, but this will most likely not always be the case. It is not intendend to be an extensive porting guide.

### New devices
1. Run ./scripts/io_gen.py with the device header from the Atmel DFP.
	(eg. python3 ./scripts/io_gen.py $(DFP_FOLDER)/include/avr/iom4808.h)
2. Put the script output in ./src/ioreg.cc and the variable name in ./src/ioreg.h.
3. Add the device in ./src/devdescr.cc and fill with info based on datasheet and .atdf file in Atmel DFP.
4. Other changes might be needed. Example for ATmega4808:
	- The new megaAVR0 or AVR8x family can have more than 8 fuses, but AVaRICE only supported up to 8. Some functions may require updating to support this.

### New debugger protocols
[Microchip EDBG-based Tools Protocols](http://ww1.microchip.com/downloads/en/DeviceDoc/50002630A.pdf) is a great source of info on this. Hopefully it will be updated if newer protocols emerge.
1. A new command line option may need to be added in ./src/main.cc which sets needed internal variables. Example for UPDI:<br>
	- -u, --updi which sets `proto = PROTO_UPDI`
	- The new enum option for proto is added in ./src/jtag.h.
2. If device descriptor has a different layout for this protocol, create a new structure in ./src/jtag.h and add a member of this type to jtag_device_def_type. Example for UPDI:<br>
	- The device descriptor is sent as parameters in context `AVR8_CTXT_DEVICE` (section 7.1.3.1 SET/GET Parameters). The following structure results:
	```c
	struct updi_device_desc {
		unsigned char prog_base[2];
		unsigned char flash_page_size;
		unsigned char eeprom_page_size;
		unsigned char nvm_base_addr[2];
		unsigned char ocd_base_addr[2];
	};
	```
3. Depending on the differences between the new protocol and the ones already implemented, changes have to be made in ./src/jtagx___.cc or .h files or a new set of files must be added. Example for UPDI:
	- ./src/jtag3.h has new enum values for `PARM3_ARCH_UPDI` and `PARM3_CONN_UPDI`. These are transmitted as parameters `AVR8_CONFIG_VARIANT` and `AVR8_PHY_PHYSICAL`, respectively (section 7.1.3.1 SET/GET Parameters).
	- in ./src/jtag3io.cc
		- function `jtag3::setDeviceDescriptor` formats and sends the device descriptor transmitted. There is a new device descriptor for UPDI
		- function `jtag3::startJtagLink` performs the initialization sequence. This means:
			- setting the ARCH and CONN parameters to the new UPDI values
			- there is a quirk for UPDI in that the device descriptor must be sent before the sign-on/activate physical command. This is not mandatory for JTAG devices.
			- the response to the sign on command contains a generic "mega" encoded in ASCII characters, unlike other protocols which provide the device signature here.
	- in ./src/jtag3rw.cc
		- function `jtag3::jtagRead` maps an internal address to actual address space & address which will be requested from the device. For the signature address space, the exact address of the signature row must also be sent. This is fixed at 0 for other JTAGs.
		- function `jtag3::memorySpace` does the mapping of address to address space and it must be ensured that from both this function and `jtag3::jtagRead` the output is always an address and address space which matches the requirements of the protocol. For UPDI:
			- the default address was incorrectly set to SPM (which doesn't exist) instead of Flash.
			- accessing flash must be aligned to instruction words (16 bits), but GDB may not request aligned locations.

Forked from latest sources at [AVaRICE Project](http://avarice.sourceforge.net/).

Thanks to all the contributors for helping extend the list of supported devices!
