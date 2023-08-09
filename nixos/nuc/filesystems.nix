{
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/5a7204ff-0f87-461b-84d2-1707f55f66fd";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/3AB2-CE2C";
      fsType = "vfat";
    };

  swapDevices = [ ];
}
