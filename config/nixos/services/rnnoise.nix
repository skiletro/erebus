{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.erebus.services.rnnoise.enable = lib.mkEnableOption "RNNoise Microphone Noise Cancelling";

  # TODO: convert to module, and figure out a way to prioritis/select Blue Snowball
  config = lib.mkIf config.erebus.services.rnnoise.enable {
    home-manager.sharedModules = lib.singleton {
      xdg.configFile."pipewire/pipewire.conf.d/99-input-denoising.conf".text = builtins.toJSON {
        "context.modules" = [
          {
            "name" = "libpipewire-module-filter-chain";
            "args" = {
              "node.description" = "Noise Canceling source";
              "media.name" = "Noise Canceling source";
              "filter.graph" = {
                "nodes" = [
                  {
                    "type" = "ladspa";
                    "name" = "rnnoise";
                    "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                    "label" = "noise_suppressor_stereo";
                    "control" = {
                      "VAD Threshold (%)" = 85.0;
                      "VAD Grace Period (ms)" = 350;
                      "Retroactive VAD Grace (ms)" = 80;
                    };
                  }
                ];
              };
              "audio.position" = [
                "FL"
                "FR"
              ];
              "capture.props" = {
                "node.name" = "effect_input.rnnoise";
                "node.passive" = true;
              };
              "playback.props" = {
                "node.name" = "effect_output.rnnoise";
                "media.class" = "Audio/Source";
              };
            };
          }
        ];
      };
    };
  };
}
