{ lib, buildGoModule, fetchFromGitHub}:

buildGoModule rec {
  pname = "cilium-cni";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "cilium";
    rev = "v${version}";
    sha256 = "sha256-xJFwBCnJemskm42/J4JNYrMO47REUYfc51bTJqckA7g=";
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
