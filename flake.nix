{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      python = pkgs.python3.withPackages (ps:
        with ps; [
          mkdocs-material
          mkdocs-git-revision-date-localized-plugin
          pip
        ]);
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          python
          pkgs.git
        ];

        shellHook = ''
          if ! python -c "import mkdocs_static_i18n" 2>/dev/null; then
            echo "Installing mkdocs-static-i18n via pip..."
            pip install --user mkdocs-static-i18n
          fi
        '';
      };
    });
}
