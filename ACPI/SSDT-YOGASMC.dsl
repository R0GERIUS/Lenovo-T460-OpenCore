//
// Helper-methods for YogaSMC
//
DefinitionBlock ("", "SSDT", 2, "T460", "YOGA", 0x00001000)
{
    External (_SB_.PCI0.LPC.EC, DeviceObj)
    External (_SB_.PCI0.LPC.EC.HKEY, DeviceObj)
    External (_SI_._SST, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPC.EC.HFSP, FieldUnitObj)
    External (_SB_.PCI0.LPC.EC.HFNI, FieldUnitObj)
    External (_SB_.PCI0.LPC.EC.VRST, FieldUnitObj)

    /*
     * ThinkSMC sensor access
     * Double check name of FieldUnit for collision
     * Registers return 0x00 for non-implemented, 
     * and return 0x80 when not available.
     */
    Scope (_SB_.PCI0.LPC.EC)
    {
        OperationRegion (ESEN, EmbeddedControl, Zero, 0x0100)
        Field (ESEN, ByteAcc, Lock, Preserve)
        {
            // TP_EC_THERMAL_TMP0
            Offset (0x78), 
            EST0,   8, // CPU
            EST1,   8, 
            EST2,   8, 
            EST3,   8, // GPU ?
            EST4,   8, // Battery ?
            EST5,   8, // Battery ?
            EST6,   8, // Battery ?
            EST7,   8, // Battery ?
            
            // TP_EC_THERMAL_TMP8
            Offset (0xC0), 
            EST8,   8, 
            EST9,   8, 
            ESTA,   8, 
            ESTB,   8, 
            ESTC,   8, 
            ESTD,   8, 
            ESTE,   8, 
            ESTF,   8
        }

        /**
         * Proxy methods for YogaSMC
         */
        Scope (HKEY)
        {
            // Used as a proxy-method to interface with \_SI._SST in YogaSMC
            Method (CSSI, 1, NotSerialized)
            {
                \_SI._SST (Arg0)
            }

            // Optional: Write access to fan control register
            Method (CFSP, 1, NotSerialized)
            {
                \_SB.PCI0.LPC.EC.HFSP = Arg0
            }

            Method (CFNI, 1, NotSerialized)
            {
                \_SB.PCI0.LPC.EC.HFNI = Arg0
            }

            Method (CRST, 1, NotSerialized)
            {
                \_SB.PCI0.LPC.EC.VRST = Arg0
            }
        }
    }
}
//EOF
