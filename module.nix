inputs:
{
  config,
  lib,
  system,
  ...
}:
let
  cfg = config.rust;

  inherit (lib) types;
  inherit (lib.attrsets) attrValues;
  inherit (lib.options) mkEnableOption mkOption;

  toolchain = inputs.fenix.packages.${system}.stable;
in
{
  options.rust = {
    enable = mkEnableOption "rust development environment";
    package = mkOption {
      type = with types; package;
      default = toolchain.rust;
      defaultText = "whichever rust package `version` chooses";
      description = ''
        rust package to use.
      '';
    };
    /*
      version = mkOption {
        type =
          with types;
          oneOf [
            "beta"
            "nightly"
            "stable"
            semverPattern
          ];
        default = "stable";
      };
    */
  };

  config = lib.mkIf cfg.enable {
    shell.packages = attrValues {
      inherit (toolchain)
        cargo
        rust-src
        rustc
        rustfmt
        ;
    };
  };
}
