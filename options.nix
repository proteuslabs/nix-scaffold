{ config, pkgs, lib, ... }:

with lib;

let
  fileOptions = {config, name, ...}: {
    name = mkOption {
      description = "Name of the file";
      type = types.str;
      default = name;
    };

    text = mkOption {
      description = "Text to put in a file";
      type = types.lines;
      default = "";
    };

    data = mkOption {
      description = "Data to put in a file";
      type = types.attrs;
      default = {};
    };

    format = mkOption {
      description = "Format of data";
      type = types.enum ["json" "yaml"];
      default = "json";
    };
  };
in {
  options = {
    scaffold.files = mkOption {
      description = "Attribute set of files to generate";
      type = types.attrsOf types.optionSet;
      default = {};
      options = [fileOptions];
    };

    scaffold.before = mkOption {
      description = "List of commands to run before generating files";
      default = [];
      type = types.listOf types.str;
    };

    scaffold.after = mkOption {
      description = "List of commands to run after generating files";
      default = [];
      type = types.listOf types.str;
    };
  };
}
