{
  # This fixes the "too many files open" error on build.
  # When bootstrapping the config, you might need to type this manually.
  environment.interactiveShellInit =
    # sh
    ''
      ulimit -s unlimited
    '';
}
