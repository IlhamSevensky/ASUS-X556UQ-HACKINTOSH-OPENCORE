DefinitionBlock("", "SSDT", 2, "hack", "atk", 0)
{
    External (_SB.ATKD, DeviceObj)
    External (_SB.ATKD.IANE, MethodObj) 
    External (_SB.ATKD.PWKB, BuffObj)
    External (_SB.KBLV, FieldUnitObj)
    External (_SB.PCI0.LPCB.EC0_, DeviceObj)
    External (_SB.PCI0.LPCB.EC0_.ATKP, IntObj)
    External (_SB.PCI0.LPCB.EC0_.WRAM, MethodObj)    
    External (_SB.PCI0.LPCB.EC0_.XQ0E, MethodObj)   
    External (_SB.PCI0.LPCB.EC0_.XQ0F, MethodObj)
    
    Scope (_SB.PCI0.LPCB.EC0)
    {
        Method (_Q0E) 
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x20)
            }

            XQ0E()
        }

        Method (_Q0F) 
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x10)
            }

            XQ0F()
        }
    }

    Scope (_SB.ATKD)
    {
        Name (BOFF, Zero)
        Method (SKBL, 1, NotSerialized)
        {
            If (Or (LEqual (Arg0, 0xED), LEqual (Arg0, 0xFD)))
            {
                If (And (LEqual (Arg0, 0xED), LEqual (BOFF, 0xEA)))
                {
                    Store (Zero, Local0)
                    Store (Arg0, BOFF)
                }
                Else
                {
                    If (And (LEqual (Arg0, 0xFD), LEqual (BOFF, 0xFA)))
                    {
                        Store (Zero, Local0)
                        Store (Arg0, BOFF)
                    }
                    Else
                    {
                        Return (BOFF)
                    }
                }
            }
            Else
            {
                If (Or (LEqual (Arg0, 0xEA), LEqual (Arg0, 0xFA)))
                {
                    Store (KBLV, Local0)
                    Store (Arg0, BOFF)
                }
                Else
                {
                    Store (Arg0, Local0)
                    Store (Arg0, KBLV)
                }
            }
            Store (DerefOf (Index (PWKB, Local0)), Local1)
            ^^PCI0.LPCB.EC0.WRAM (0x04B1, Local1)
            Return (Local0)
        }

        Method (GKBL, 1, NotSerialized)
        {
            If (LEqual (Arg0, 0xFF))
            {
                Return (BOFF)
            }

            Return (KBLV)
        }
    }
}