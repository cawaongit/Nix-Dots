{ config, pkgs, modulesPath, ... }:

{
  imports =
  [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ./../../flake.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
}
