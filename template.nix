{
  nodejs = {options, lib, ...}: with lib; {
    options.arguments.author.name = mkOption {
      description = "Name of the author of the project";
      type = types.str;
    };

    options.arguments.author.homepage = mkOption {
      description = "Homepage of the project";
      type = types.str;
      default = "http://google.com";
    };
  };
}
