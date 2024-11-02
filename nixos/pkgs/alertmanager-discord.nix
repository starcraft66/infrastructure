{ lib, fetchpatch, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "alertmanager-discord";
  version = "unstable-12082022";

  src = fetchFromGitHub {
    owner = "benjojo";
    repo = "alertmanager-discord";
    rev = "89ef841a7ef43c5520df49d0c28335d899230eb9";
    sha256 = "sha256-6P90c3ECUtmXxr2b0/yVscSI/bBgpXkrhou7Cne/bEM=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Take your alertmanager alerts, into discord";
    homepage = "https://github.com/benjojo/alertmanager-discord";
    license = licenses.asl20;
    maintainers = with maintainers; [ starcraft66 ];
  };
}
