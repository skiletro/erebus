{inputs, ...}: {
  flake = {
    inherit (inputs.flake-schemas) schemas;
  };
}
