{
  description = "NixOS (WSL + Home Manager) - flake native";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NixOS-WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }:
  let
    system = "x86_64-linux"; # aarch64-linux on ARM
    pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations = {
      # Use your host name here if you want to run `--flake .` without `#name`
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        # If you prefer to reference inputs inside configuration.nix, pass them:
        # specialArgs = { inherit home-manager nixos-wsl; };

        modules = [
          # Replace the legacy `<nixos-wsl/modules>` with:
          nixos-wsl.nixosModules.default

          # Replace the legacy `<home-manager/nixos>` with:
          home-manager.nixosModules.home-manager

          # Your regular system config
          ./configuration.nix

          # Optional: define a basic HM user here (or keep it in configuration.nix)
          {
            # Home Manager needs a user to manage.
            # Change "nixos" to your actual login if different.
            home-manager.users.nixos = { pkgs, ... }: {
              # Put HM options here or in ./home.nix
              # programs.zsh.enable = true;
              # home.stateVersion = "24.11";
            };
          }
        ];
      };
    };
  };
}

