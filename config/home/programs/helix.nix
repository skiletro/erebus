{
  lib,
  config,
  pkgs,
  inputs',
  ...
}:
{
  options.erebus.programs.helix.enable = lib.mkEnableOption "Helix editor";

  config = lib.mkIf config.erebus.programs.helix.enable {
    programs.helix = {
      enable = true;
      package = inputs'.helix.packages.helix.overrideAttrs (_prevAttrs: {
        patches = [
          # Keep LSP completions active when typing server-trigger characters
          (pkgs.fetchurl {
            url = "https://patch-diff.githubusercontent.com/raw/helix-editor/helix/pull/14556.patch";
            sha256 = "sha256-YLohyMbQMKcOu16BhyJ0jwTfjX0JkPuX5z7xgwI+AMc=";
          })
        ];
      });
      extraPackages = with pkgs; [
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
        dockerfile-language-server # Dockerfile
        marksman # Markdown
        taplo # TOML
        yaml-language-server # YAML
        omnisharp-roslyn # C#
        csharpier # C#
        netcoredbg # C#
        mono # C#
        msbuild # C# Unity
      ];
      defaultEditor = true;
      languages = {
        language-server = {
          emmet-lsp = {
            command = lib.getExe pkgs.emmet-language-server;
            args = [ "--stdio" ];
          };
          gopls.config.gofumpt = true;
          harper = {
            command = lib.getExe pkgs.harper;
            args = [ "--stdio" ];
            config.harper-ls.dialect = "British";
          };
        };
        language = [
          {
            name = "html";
            formatter = {
              command = "prettier";
              args = [
                "--parser"
                "html"
              ];
            };
            language-servers = [
              "vscode-html-language-server"
              "emmet-lsp"
            ];
          }
          {
            name = "tsx";
            formatter = {
              command = "prettier";
              args = [
                "--parser"
                "typescript"
              ];
            };
            language-servers = [
              "vscode-html-language-server"
              "emmet-lsp"
            ];
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
            language-servers = [ "clangd" ];
          }
          {
            name = "markdown";
            language-servers = [
              "marksman"
              "harper"
            ];
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
          rulers = [ 120 ];
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
            left = [
              "mode"
              "separator"
              "read-only-indicator"
              "file-modification-indicator"
            ];
            center = [ "file-name" ];
            right = [
              "spinner"
              "version-control"
              "position"
              "file-encoding"
              "file-line-ending"
              "file-type"
            ];
          };
        };
        keys = {
          normal = {
            "ret" = "goto_word";
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
            "B" =
              ":sh git log -n 5 --format='format:%%h (%%an: %%ar) %%s' --no-patch -L%{cursor_line},+1:%{buffer_name}";
          };
          select = {
            "X" = "select_line_above";
          };
        };
      };
    };
  };
}
