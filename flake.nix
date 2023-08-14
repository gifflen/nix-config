{
  description = "My NixOs Config";

  inputs = {
    # Nixpkgs
    nixpkgs2305.url = "github:nixos/nixpkgs/nixos-23.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix.url = "github:Mic92/sops-nix";
    nixpkgs-fmt = {
      url = "github:nix-community/nixpkgs-fmt/v1.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      conf = self.nixosConfigurations;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        #        "i686-linux"
        "x86_64-linux"
        #        "aarch64-darwin"
        #        "x86_64-darwin"
      ];
    in
    rec {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        nuc = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main nixos configuration file <
            ./nixos/nuc/configuration.nix
          ];
        };
        pi3 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main nixos configuration file <
            ./nixos/pi3/configuration.nix
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "gifflen@werkwerk" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./home-manager/gifflen/home.nix
          ];
        };
        "gifflen@pi" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./home-manager/gifflen/home.nix
          ];
        };

        "bstringer" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./home-manager/bstringer/home.nix
          ];
        };
      };
      deploy.nodes = {
        nuc = {
          hostname = "nuc";
          profiles.system = {
            user = "root";
            sshUser = "gifflen";
            hostname = "nuc";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nuc;
          };
        };
#        pi3 = {
#          hostname = "192.168.1.143";
#          profiles.system = {
#            user = "root";
#            sshUser = "gifflen";
#            hostname = "192.168.1.143";
#            path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.nuc;
#          };
#        };
      };
      colmena = {
        meta = {
          description = "My personal machines";
          nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
          nodeNixpkgs = builtins.mapAttrs (name: value: value.pkgs) conf;
          nodeSpecialArgs = builtins.mapAttrs (name: value: value._module.specialArgs) conf;
        };
        nuc = {name, nodes, pkgs, ...}: {
          boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
          deployment = {
            targetHost = "nuc";
            targetUser = "gifflen";

          };
        };
        pi3 = {name, nodes, pkgs, ...}: {
          deployment = {
            targetHost = "192.168.1.143";
            targetUser = "gifflen";
            buildOnTarget = true;
          };
          nixpks.system = "aarch64-linux";
        };
      } // builtins.mapAttrs (name: value: { imports = value._module.args.modules; }) conf;
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
    };
}
