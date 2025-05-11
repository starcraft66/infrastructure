{ inputs, ... }:

let
  systems = {
    sassaflash = import ./sassaflash { inherit inputs lib; };
    stormfeather = import ./stormfeather { inherit inputs lib; };
    soarin = import ./soarin { inherit inputs lib; };
    stone = import ./stone { inherit inputs; };
    lava = import ./lava { inherit inputs; };
    spike = import ./spike { inherit inputs lib; };
  };

  inherit (inputs.nixpkgs) lib;

  combine = a: b: a // b;
  combineAll = list: builtins.foldl' combine { } list;
  allAttrNames = list: builtins.attrNames (combineAll list);
  merge = list:
    combineAll (map (key: { ${key} = combineAll (builtins.catAttrs key list); })
      (allAttrNames list));

  generateNixosSystems = builtins.mapAttrs (name: system:
    system.nixosInput.lib.nixosSystem {
      inherit (system) system pkgs;
      modules = system.modules ++ [ ./${name}/bootloader.nix ] ++ (import ../modules);
      specialArgs = { inherit inputs; };
    });

  generateVmImages = systems:
    lib.mapAttrsToList (name: system: {
      ${system.system}.${name} = (inputs.nixos-generators.nixosGenerate {
        inherit (system) pkgs format;
        # https://github.com/nix-community/nixos-generators/blob/bf351a252ace47ad8f49b9da7fb23960d2016cbc/flake.nix#L67
        inherit (system.nixosInput.lib) nixosSystem;
        # Avoid conflicts between system and live media
        modules = lib.remove ./${name}/bootloader.nix (system.modules ++ (import ../modules));
        specialArgs = { inherit inputs; };
      });
    }) systems;

  generateDeployRsProfiles = systems:
    lib.mapAttrsToList (name: system: {
      nodes.${name} = {
        inherit (system) hostname magicRollback;
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = inputs.deploy-rs.lib.${system.system}.activate.nixos
            inputs.self.nixosConfigurations.${name};
        };
      };
    }) systems;

  generateColmenaNodes = systems:
    lib.mapAttrs
      (name: system: { name, nodes, ... }:
        {
          imports = system.modules ++ (import ../modules) ++
          [ ./${name}/bootloader.nix
            ./${name}/keys.nix
            # Replicate the setup in
            # https://github.com/NixOS/nixpkgs/blob/23cbb250f3bf4f516a2d0bf03c51a30900848075/flake.nix#L33-L41
            # because colmena instantiates nixpkgs differently
            # We also can't just pass the nixpkgs input to colmena instead of an already-instantiated version
            # because it leads to:
            # error: Passing a path to Nixpkgs as meta.nodeNixpkgs.spike is no longer accepted with Flakes.
            ({ config, pkgs, lib, ... }: {
              config.nixpkgs.flake.source = system.nixosInput.outPath;
            })
          ];
          deployment = {
            targetUser = "root";
            targetHost = system.hostname;
            targetPort = 22;
            replaceUnknownProfiles = true;
            tags = system.tags or [];
          };
        })
      systems;

  generateColmenaNixpkgs = systems:
    lib.mapAttrs (name: system: system.pkgs) systems;

  mergeVmImages = systems: merge (generateVmImages systems);

  mergeDeployRsProfiles = systems: merge (generateDeployRsProfiles systems);
in {
  nixosConfigurations = generateNixosSystems systems;
  packages = mergeVmImages systems;
  deploy = mergeDeployRsProfiles systems;
  colmenaHive = inputs.colmena.lib.makeHive ((generateColmenaNodes systems) // {
    meta = {
      # dummy nixpkgs that won't be used
      nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
      specialArgs = {
        inherit inputs;
      };
      nodeNixpkgs = generateColmenaNixpkgs systems;
    };
  });
  checks =
    builtins.mapAttrs (system: deployLib: deployLib.deployChecks inputs.self.deploy)
    inputs.deploy-rs.lib;
}
