{ pkgs ? import <nixpkgs> {}
, template ? ./test.nix, args ? null
, templateAttr ? "", ... }:

with pkgs.lib;

with import ./lib.nix { inherit (pkgs) lib; inherit pkgs; };

let
  templateConfig =
    if templateAttr != ""
    then getAttr templateAttr (import template)
    else template;
in {
  options = pkgs.writeText "options.json" (builtins.toJSON (
    getOptions templateConfig
  ));
}
