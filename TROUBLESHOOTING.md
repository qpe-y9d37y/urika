# Troubleshooting

## Grub-install dummy

If you face the following message:
'''
Unable to install GRUB in dummy
Executing 'grub-install dummy' failed.
'''
Try not to force the installation in UEFI mode but in BIOS mode instead.

## Grub-efi-amd64 

If you face the following message:
'''
GRUB installation failed
The 'grub-efi-amd64' package failed to instal into /target/. Without the GRUB boot loader, the installed system will not boot.
'''
Try to delete all existing partitions with GParted first.

## Update coreboot firmware (BIOS)

To update coreboot firmware (BIOS), do:
'''
cd ~
curl -L -O http://mrchromebox.tech/firmware-util.sh
sudo bash firmware-util.sh
'''
