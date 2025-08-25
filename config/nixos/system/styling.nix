{
  config,
  inputs,
  pkgs,
  ...
}: {
  stylix.cursor = {
    package = with config.lib.stylix.colors.withHashtag;
      inputs.cursors.packages.${pkgs.system}.bibata-modern-cursor.override {
        background_color = base00;
        outline_color = base06;
        accent_color = base00;
      };
    name = "Bibata-Modern-Custom";
    size = 24;
  };
}
