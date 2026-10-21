DefinitionBlock ("", "SSDT", 2, "hack", "DGPU", 0x00000000)
{
    External (_SB_.PCI0.PEG0.PEGP._OFF, MethodObj)
    External (_SB_.PCI0.PEG0.PEGP._DSM, MethodObj)
    External (_SB_.PCI0.PEG0.PEGP._PS3, MethodObj)
    External (ZWAK, MethodObj)

    Method (DGPU, 0, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            If (CondRefOf (\_SB.PCI0.PEG0.PEGP._OFF))
            {
                \_SB.PCI0.PEG0.PEGP._OFF ()
            }

            If (CondRefOf (\_SB.PCI0.PEG0.PEGP._DSM) && CondRefOf (\_SB.PCI0.PEG0.PEGP._PS3))
            {
                \_SB.PCI0.PEG0.PEGP._DSM (ToUUID ("a486d8f8-0bda-471b-a72b-6042a6b5bee0"), 0x0100, 0x1A, Buffer (0x04)
                {
                    0x01, 0x00, 0x00, 0x03
                })
                \_SB.PCI0.PEG0.PEGP._PS3 ()
            }
        }
    }

    Scope (\_SB)
    {
        Device (RMD1)
        {
            Name (_HID, "RMD10000")
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_INI, 0, NotSerialized)
            {
                DGPU ()
            }
        }
    }

    Method (_WAK, 1, NotSerialized)
    {
        Local0 = ZWAK (Arg0)
        DGPU ()
        Return (Local0)
    }
}
