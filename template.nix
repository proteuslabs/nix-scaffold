{
  nodejs = {options, lib, ...}: with lib; {
    options.questions.author.name = mkOption {
      description = "Name of the author of the project";
      type = types.str;
    };

    options.questions.author.homepage = mkOption {
      description = "Homepage of the project";
      type = types.str;
      default = "http://google.com";
    };
  };
}
