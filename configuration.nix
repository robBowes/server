# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
 <home-manager/nixos>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";
  
  nixpkgs.config.allowUnfree = true; 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  environment.systemPackages = with pkgs; [
    vim
    git
    python314
    cudaPackages.cudnn
    code-cursor
  ];
    programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;


  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    # Your zsh config
    enable = true;
    enableAutosuggestions = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "autojump" ];
      theme = "robbyrussell";
    };
  };
  
  home-manager = {
    useUserPackages = true;
    users.nixos = {
      home.stateVersion = "24.05";  # Adjust based on your NixOS version
      programs.vim.enable = true;   # Example: enable Vim via Home Manager
    };
  };
}
