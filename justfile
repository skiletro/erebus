export NH_FLAKE := justfile_directory()
system := if os() == "macos" { "darwin" } else { "os" }

[private]
default:
    @just -l -u

[group("rebuild")]
[private]
builder goal *args:
    @echo -e "\e[35m>\e[0m Formatting code..."
    @nix fmt
    @echo -e "\e[35m>\e[0m Staging commits..."
    @git add .
    @nh {{ system }} {{ goal }} -- {{ args }}

[group("rebuild")]
switch *args: (builder "switch" args)

[group("rebuild")]
boot *args: (builder "boot" args)

[group("rebuild")]
test *args: (builder "test" args)

[group("housekeeping")]
update *input:
    @echo -e "\e[35m>\e[0m Updating flake inputs..."
    @nix flake update {{ input }} --refresh

[group("housekeeping")]
repl *args: (builder "repl" args)

[group("housekeeping")]
clean:
    @echo -e "\e[35m>\e[0m Cleaning Nix store..."
    @nh clean all -K 1d
    @echo -e "\e[35m>\e[0m Optimising Nix store..."
    @nix store optimise

[group("housekeeping")]
repair:
    @echo -e "\e[35m>\e[0m Verifying Nix store..."
    @nix-store --verify --check-contents --repair
