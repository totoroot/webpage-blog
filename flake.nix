{
  description = "totoroot's blog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Import theme
    stack = {
      url = "git+https://codeberg.org/totoroot/hugo-theme-stack?ref=main";
      flake = false;
    };
    plausible = {
      url = "git+https://github.com/totoroot/plausible-hugo?ref=master";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, stack, plausible }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        blog = pkgs.stdenv.mkDerivation {
          name = "blog";
          # Exclude themes and public folder from build sources
          src = builtins.filterSource
            (path: type: !(type == "directory" &&
              (baseNameOf path == "themes" ||
                baseNameOf path == "public")))
            ./.;
          # Link to themes folder and build
          buildPhase = ''
            rm -rf themes
            mkdir -p themes
            ln -sf ${stack} themes/stack
            ln -sf ${plausible} themes/plausible-hugo
            ls themes -l
            ${pkgs.hugo}/bin/hugo --minify
          '';
          installPhase = ''
            cp -r public $out
          '';
          meta = with pkgs.lib; {
            description = "totoroot's blog";
            platforms = platforms.all;
          };
        };
      in
      {
        packages = {
          blog = blog;
          default = blog;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ hugo ];
          # Link to themes folder
          shellHook = ''
            rm -rf themes
            mkdir -p themes
            ln -sf ${stack} themes/stack
            ln -sf ${plausible} themes/plausible-hugo
          '';
        };
      });
}
