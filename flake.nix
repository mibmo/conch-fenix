{
  description = "Rust module for Conch";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    conch = {
      url = "github:mibmo/conch/modularity";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ ... }:
    {
      conchModules = rec {
        default = rust;
        rust = import ./module.nix inputs;
      };
    };
}
