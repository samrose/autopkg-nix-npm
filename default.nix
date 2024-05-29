{ lib, config, dream2nix, ... }:

let
  sourceFile = ./source.json; # Path to the JSON file
  source = builtins.fromJSON (builtins.readFile sourceFile);
in
{
  imports = [
    dream2nix.modules.dream2nix.nodejs-package-lock-v3
    dream2nix.modules.dream2nix.nodejs-granular-v3
  ];

  mkDerivation = {
    src = config.deps.fetchFromGitHub {
      owner = source.owner;
      repo = source.repo;
      rev = source.rev;
      sha256 = source.sha256;
    };
  };

  deps = { nixpkgs, ... }: {
    inherit
      (nixpkgs)
      fetchFromGitHub
      stdenv
      ;
  };

  nodejs-package-lock-v3 = {
    packageLockFile = "${config.mkDerivation.src}/package-lock.json";
  };

  name = "cowsay";
  version = "1.5.0";
}
