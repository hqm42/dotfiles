# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1fe77924-cf14-400c-b5b4-82b71de188eb";
      fsType = "btrfs";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/2a60d8a8-4afd-44c8-884b-e67f66ea4800";
      fsType = "btrfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/6f93b60d-e71e-4c46-a621-69fbeae3a409"; }
    ];

  nix.maxJobs = lib.mkDefault 4;
}
