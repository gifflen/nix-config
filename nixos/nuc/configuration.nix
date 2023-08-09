# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./filesystems.nix
    ./networking.nix
    ./authKeys.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # FIXME: Add the rest of your current configuration

  # TODO: Set your hostname
  networking.hostName = "nuc";

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
#  boot.loader.systemd-boot.enable = true;

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    root = {
      openssh.authorizedKeys.keys = keys;
    };
    gifflen = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = keys;
#      openssh.authorizedKeys.keys = [
#
#        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCgWlHfJrGw6xYcVRSklSOLLykTDrkIEc0VU8lCc7uQK6DbLFFM5s3RSg11g6sDoQ6G3unFVQmBHL/Iq/QhzGfR7/2SgQjPp7fjJCHQXFpRgShqC6MP5gOL5LyfL+xGDKzaw2ZQatJhp8jA/KHpJeHW6lVdDZAeNC/mDr54VBimjc7CNgCkvGJ+/dJfKhuMZ76FU0nrR+8f9nrPQeRyE0AJP42W+XQBYmXebcJrzh3wiLRXzNVSl7uj2N4Jt3ovI0qGAuJ3ko7eyA5eJawnU5m7lNIXnw8Vj2qElz1yHo7TLlmOX4gb05yG4o466f5Hm2zo+Pv6PNR0tk41coC0RFKE6vjrPaQfzDAOMQ+vgdSUTk+D2QHqjlh4sRRPOe3IijkmLG6bRSTnI9sBu6DhQsNYFErvYBvicurGZ9rr5fbXh2Yr3bFK6qFwwwSwTv5eIW3JmwmHJilaNDDJwZ2rgnnsOycyFFs+tY/wd8V8EssIiu5mO3wJPNZH55TvVdp5SSE= gifflen@werkwerk"
#      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" "networkmanager" "docker" ];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    # permitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    # passwordAuthentication = false;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "amdgpu"
  ];
  boot.kernelModules = [
    "kvm-amd"
  ];
  boot.extraModulePackages = [ ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    nix.settings.trusted-users = [
    "root"
    "gifflen"
    "@wheel"
  ];

  security.sudo.wheelNeedsPassword = false;

}
