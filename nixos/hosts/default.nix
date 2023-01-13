{ inputs, ... }:

let
  systems = {
    stormfeather = import ./stormfeather { inherit inputs; };
  };

  inherit (inputs.nixpkgs) lib;

  combine = a: b: a // b;
  combineAll = list: builtins.foldl' combine { } list;
  allAttrNames = list: builtins.attrNames (combineAll list);
  merge = list:
    combineAll (map (key: { ${key} = combineAll (builtins.catAttrs key list); })
      (allAttrNames list));

  # we aren't using the nixosSystem from the target nixpkgs but it likely doesn't matter
  generateNixosSystems = builtins.mapAttrs (name: system:
    lib.nixosSystem {
      inherit (system) system pkgs;
      modules = system.modules ++ (import ../modules);
      specialArgs = { inherit inputs; };
    });

  generateVmImages = systems:
    lib.mapAttrsToList (name: system: {
      ${system.system}.${name} = (inputs.nixos-generators.nixosGenerate {
        inherit (system) pkgs format;
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

  mergeVmImages = systems: merge (generateVmImages systems);

  mergeDeployRsProfiles = systems: merge (generateDeployRsProfiles systems);
in {
  nixosConfigurations = generateNixosSystems systems;
  packages = mergeVmImages systems;
  deploy = mergeDeployRsProfiles systems;
  checks =
    builtins.mapAttrs (system: deployLib: deployLib.deployChecks inputs.self.deploy)
    inputs.deploy-rs.lib;
}
