{ ... }: {
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/d605cb1e-bbcc-4561-9cce-6e1cd83a028a";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/5241-ED14";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/7ff3faf5-4011-4197-808b-b3f91fcf1d1f"; }];
}
