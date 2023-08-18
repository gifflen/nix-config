{ name, lib, ... }: {
  networking.networkmanager.enable = true;
  networking.hostName = "werkwerk";
}
