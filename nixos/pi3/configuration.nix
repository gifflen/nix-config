# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):

    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    #    ./hardware-configuration.nix
    #    ./filesystems.nix
    ./networking.nix
    ./boot.nix
    ../common/common.nix
    ../common/sops.nix
    ../common/tailscale.nix
    ../common/nix.nix
    ../common/nixpkgs.nix
    ../common/users.nix
    ../common/pi/hardware-configuration.nix

  ];



  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      gifflen = import ../../home-manager/gifflen/home.nix;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

#  hardware.raspberry-pi."4".fkms-3d.enable = true;


}
