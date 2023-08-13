{ lib, ... }:
let
  name = "pi3";
  ip = "192.168.1.143";
in
{

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = name;
    defaultGateway = "192.168.1.1";
    nameservers = [ "100.100.100.100" "1.1.1.1" "8.8.8.8" ];
    interfaces = {
      end0.ipv4.addresses = [{
        address = ip;
        prefixLength = 24;
      }];
    };

  };


}
