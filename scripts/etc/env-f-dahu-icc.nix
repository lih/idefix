let nixpkgs = import <nixpkgs> {};

in nixpkgs.mkShell.override { stdenv = nixpkgs.stdenvNoCC; } {
  buildInputs = with nixpkgs; [
    cmake
    pkg-config
  ];
  NIX_SHELL_PROMPT_TAG = "idefix";
  INTEL_ONEAPI = builtins.getEnv "INTEL_ONEAPI";
  shellHook = ''
    source "$INTEL_ONEAPI/setvars.sh"
  '';
}
