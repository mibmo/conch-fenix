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
  inherit (lib.attrsets) attrNames attrValues;
  inherit (lib.options) mkEnableOption mkOption;

  fenixPkgs = inputs.fenix.packages.${system};
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
    targets = mkOption {
      type = with types; listOf (enum (attrNames fenixPkgs.targets));
      default = [ ];
      description = ''
        targets to support cross compiling to.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    shell.packages =
      let
        toolchain =
          {
            inherit (fenixPkgs) stable beta;
            nightly = fenixPkgs.complete;
          }
          .${cfg.channel};
        components =
          attrValues {
            inherit (toolchain)
              cargo
              rust-src
              rustc
              rustfmt
              ;
          }
          ++ (map (target: fenixPkgs.targets.${target}.latest.rust-std) cfg.targets);
      in
      [ (fenixPkgs.combine components) ];
  };
}
