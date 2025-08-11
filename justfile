default:
    git add . && nixos-rebuild build-vm --flake .#vm --show-trace && rm -f vm.qcow2 && ./result/bin/run-vm-vm -m 8G
