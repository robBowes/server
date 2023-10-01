let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
in
pkgs.mkShell {
  buildInputs = [
    pkgs.nodejs-18_x
    pkgs.postgresql_15
    pkgs.nodePackages.pnpm
    pkgs.tmux
    pkgs.docker
    pkgs.docker-compose
  ];
}
