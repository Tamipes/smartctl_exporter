# source: https://github.com/NixOS/nixpkgs/blob/nixos-25.05/pkgs/by-name/pr/prometheus-smartctl-exporter/package.nix#L34
{ lib
, fetchFromGitHub
, buildGoModule
, nixosTests
, smartmontools
,
}:

buildGoModule rec {
  pname = "smartctl_exporter";
  version = "0.14.0";

  src = ./.;
  vendorHash = "sha256-bDO7EgCjmObNaYHllczDKuFyKTKH0iCFDSLke6VMsHI=";


  postPatch = ''
    substituteInPlace main.go README.md \
      --replace-fail /usr/sbin/smartctl ${lib.getExe smartmontools}
  '';

  ldflags = [
    "-X github.com/prometheus/common/version.Version=${version}"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) smartctl; };

  meta = with lib; {
    description = "Export smartctl statistics for Prometheus";
    mainProgram = "smartctl_exporter";
    homepage = "https://github.com/prometheus-community/smartctl_exporter";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      hexa
      Frostman
    ];
  };
}
