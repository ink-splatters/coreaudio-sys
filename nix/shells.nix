{ cargo, common, llvmPackages_17, mkShell, rustc, self, stdenvNoCC, system, ...
}: {

  default = mkShell.override { inherit (llvmPackages_17) stdenv; } {

    inherit (common)
      BINDGEN_EXTRA_CLANG_ARGS COREAUDIO_SDK_PATH RUSTFLAGS
      # LIBCLANG_PATH
      buildInputs;
    natibeBuildInputs = [ rustc cargo ];

    name = "rust-shell";

    shellHook = self.checks.${system}.pre-commit-check.shellHook + ''
      export PS1="\n\[\033[01;36m\]‹rust shell› \\$ \[\033[00m\]"
      echo -e "\nto install pre-commit hooks:\n\x1b[1;37mnix develop .#install-hooks\x1b[00m"
    '';
  };

  install-hooks = mkShell.override { stdenv = stdenvNoCC; } {
    inherit (self.checks.${system}.pre-commit-check) shellHook;
  };
}
