{ name, lib, ... }: {
  networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;
  networking.interfaces.enp2s0.ipv4.addresses = [{
    address = "192.168.1.101";
    prefixLength = 24;
  }];
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];


  networking.hostName = "nuc"; # Define your hostname.

}
