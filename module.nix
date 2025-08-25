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
in
{
  options.rust = {
    enable = mkEnableOption "rust development environment";
    channel = mkOption {
      type =
        with types;
        enum [
          "stable"
          "beta"
          "nightly"
        ];
      default = "stable";
      description = ''
        release channel to use.
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
    shell.packages =
      let
        toolchain = inputs.fenix.packages.${system}.${cfg.channel};
      in
      attrValues {
        inherit (toolchain)
          cargo
          rust-src
          rustc
          rustfmt
          ;
      };
  };
}
