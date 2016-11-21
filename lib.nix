{ pkgs, lib }: 

with lib;

rec {
  # Evaluates config
  evalConfig = modules: evalModules {
    modules = [./options.nix] ++ modules;
    args = { inherit pkgs; };
  }; 

  getOptions = config: let
		options = (evalConfig [config]).options;
		optionsList = with pkgs.lib;
			filter (opt: opt.visible && !opt.internal) (optionAttrSetToDocList options);
		# Replace functions by the string <function>
		substFunction = with pkgs.lib; x:
			if builtins.isAttrs x then mapAttrs (name: substFunction) x
			else if builtins.isList x then map substFunction x
			else if builtins.isFunction x then "<function>"
			else x;
  in  with pkgs.lib; flip map optionsList (opt: opt // {
		declarations = opt.declarations;
	}
	// optionalAttrs (opt ? description) { example = substFunction opt.description; }
	// optionalAttrs (opt ? example) { example = substFunction opt.example; }
	// optionalAttrs (opt ? default) { default = substFunction opt.default; }
	// optionalAttrs (opt ? type) { type = substFunction opt.type; });
}
