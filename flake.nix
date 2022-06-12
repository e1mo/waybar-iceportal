{
  description = "flake for waybar-iceportal";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs, ... }: let
    systems = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
		overlay = final: prev: with final; {
			waybar-iceportal = stdenv.mkDerivation rec {
			  name = "waybar-iceportal";
        buildInputs = [
          (pkgs.python39.withPackages (pp: with pp; [ requests ]))
        ];
        unpackPhase = "true";
        installPhase = ''
          mkdir -p $out/bin
          cp ${./waybar-iceportal} $out/bin/${name}
          chmod +x $out/bin/${name}
        '';
      };
		};
    nixpkgsFor = forAllSystems (system:
      import nixpkgs {
			inherit system;
			overlays = [ overlay ];
		});
  in {
    overlays.default = overlay;

    packages = builtins.mapAttrs (system: pkgs: rec {
      inherit (pkgs) waybar-iceportal;
    }) nixpkgsFor;
  };
}
