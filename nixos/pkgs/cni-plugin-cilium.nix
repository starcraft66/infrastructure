{ lib, buildGoModule, fetchFromGitHub}:

buildGoModule rec {
  pname = "cilium-cni";
  version = "1.17.3";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "cilium";
    rev = "v${version}";
    hash = "sha256-HcKRenRILpJCzJZbOYzrQrLlEeif9J9jJDKFzA6NtXc=";
  };

  vendorHash = null;

  ldflags = [
    "-s" "-w"
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
    "-X main.Program=cilium"
  ];

  subPackages = [ "./plugins/cilium-cni" ];

  # level=error msg="unable to open \"/sys/devices/system/cpu/possible\"" error="open /sys/devices/system/cpu/possible: no such file or directory" subsys=datapath-loader
  doCheck = false;

  meta = with lib; {
    description = "Cilium CNI plugin";
    homepage = "https://github.com/cilium/cilium/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ starcraft66 ];
  };
}
