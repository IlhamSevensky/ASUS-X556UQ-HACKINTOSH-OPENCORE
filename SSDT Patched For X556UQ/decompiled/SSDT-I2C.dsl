/*
 * ASUS K501UQ - OpenCore hotpatches
 * VoodooI2C compatibility patches
 * 
 * Made in assumpton of IOInterruptSpecifiers = 0x6d,
 * which corresponds to pin number 0x55. You might have
 * different pin number.
 * Refer to VoodooI2C GPIO pinning manual for details.
 *
 * Required patches:
 * GPIO pinning - _CRS => XCRS in ETPD device, DSDT only
 *     5F435253080853424649  =>  58435253080853424649 
 * GPIO enabling - replacing _STA with XSTA, DSDT only
 *     5F53544100A0099353425247 => 5853544100A0099353425247
 */
DefinitionBlock ("", "SSDT", 2, "hack", "I2C", 0x00000000)
{
    External (_SB_.PCI0.GPI0, DeviceObj)
    External (_SB_.PCI0.GPI0.XSTA, MethodObj)
    External (_SB_.PCI0.I2C1.ETPD, DeviceObj)

    Scope (_SB.PCI0.I2C1.ETPD)
    {
        Name (SBFG, ResourceTemplate ()
        {
            GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                )
                {   // Pin list
                    0x0055
                }
        })
        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
        {
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x0015, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                    0x00, ResourceConsumer, , Exclusive,
                    )
            })
            Return (ConcatenateResTemplate (SBFB, SBFG))
        }
    }
    // GPIO controller enabling patch
    Scope (_SB.PCI0.GPI0)
    {
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            Return (0x0F)
        }
    }
}