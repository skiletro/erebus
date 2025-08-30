{
  lib,
  config,
  pkgs,
  inputs',
  ...
}: {
  options.erebus.programs.helix.enable = lib.mkEnableOption "Helix editor";

  config = lib.mkIf config.erebus.programs.helix.enable {
    programs.helix = {
      enable = true;
      # package = inputs'.helix.packages.helix;
      package = let
        language-servers = with pkgs; [
          typescript-language-server # TS
          vscode-langservers-extracted # TS/JS/HTML
          prettier # HTML/CSS/JS
          rust-analyzer # Rust
          rustfmt # Rust
          clippy # Rust
          deadnix # Nix
          nixd # Nix
          nil # Nix
          gopls # Go
          bash-language-server # Bash
          docker-compose-language-service # Docker Compose
          dockerfile-language-server-nodejs # Dockerfile
          marksman # Markdown
          taplo # TOML
          yaml-language-server # YAML
          omnisharp-roslyn # C#
        ];
      in
        with pkgs;
          runCommand "helix" {buildInputs = [makeWrapper];} ''
            makeWrapper ${lib.getExe inputs'.helix.packages.helix} $out/bin/hx \
              --suffix PATH : "${
              lib.makeBinPath language-servers
            }"
          '';
      defaultEditor = true;
      languages = {
        language-server = {
          emmet-lsp = {
            command = lib.getExe pkgs.emmet-language-server;
            args = ["--stdio"];
          };
          gopls.config.gofumpt = true;
        };
        language = [
          {
            name = "html";
            formatter = {
              command = "prettier";
              args = ["--parser" "html"];
            };
            language-servers = ["vscode-html-language-server" "emmet-lsp"];
          }
          {
            name = "tsx";
            formatter = {
              command = "prettier";
              args = ["--parser" "typescript"];
            };
            language-servers = ["vscode-html-language-server" "emmet-lsp"];
          }
          {
            name = "nix";
            formatter = {
              command = lib.getExe pkgs.nixfmt;
              auto-format = true;
            };
          }
          {
            name = "fish";
            formatter.command = "fish_indent";
            auto-format = true;
          }
          {
            name = "go";
            auto-format = true;
          }
          {
            name = "c";
            formatter.command = lib.getExe' pkgs.clang-tools "clang-format";
            language-servers = ["clangd"];
          }
        ];
      };
      settings = {
        editor = {
          bufferline = "multiple";
          cursorline = true;
          true-color = true;
          color-modes = true;
          line-number = "relative";
          rainbow-brackets = true;
          rulers = [120];
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides = {
            render = true;
            skip-levels = 1;
          };
          auto-pairs = true;
          lsp = {
            auto-signature-help = false;
            display-progress-messages = true;
            display-inlay-hints = true;
          };
          end-of-line-diagnostics = "hint";
          inline-diagnostics = {
            cursor-line = "error";
            other-lines = "disable";
          };
          statusline = {
            mode = {
              normal = "NORMAL";
              insert = "INSERT";
              select = "SELECT";
            };
            separator = " ";
            left = ["mode" "separator" "read-only-indicator" "file-modification-indicator"];
            center = ["file-name"];
            right = ["spinner" "version-control" "position" "file-encoding" "file-line-ending" "file-type"];
          };
        };
        keys = {
          normal = {
            "X" = "select_line_above";
            "C-e" = [
              ":sh rm -f /tmp/hx-unique-file"
              ":insert-output ${lib.getExe config.programs.yazi.package} %{buffer_name} --chooser-file=/tmp/hx-unique-file"
              ":insert-output echo '\\x1b[?1049h\\x1b[?2004h' > /dev/tty"
              ":open %sh{cat /tmp/hx-unique-file}"
              ":redraw"
              ":set-option mouse false"
              ":set-option mouse true"
            ];
            "C-g" = [
              ":insert-output ${lib.getExe config.programs.lazygit.package}"
              ":insert-output echo '\\x1b[?1049h\\x1b[?2004h' > /dev/tty"
              ":redraw"
              ":set-option mouse false"
              ":set-option mouse true"
            ];
          };
          select = {
            "X" = "select_line_above";
          };
        };
      };
    };
  };
}
