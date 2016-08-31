docker run -ti --rm \
-v $(pwd)/../pkgs:/pkgs \
-e VERSION_MOARVM=2016.08 \
-e VERSION_NQP=2016.08.1 \
-e VERSION_RAKUDO=2016.08.1 \
-e VERSION_PKG=20160801_01 \
nxadm/pkgrakudo-ubuntu16.04-i386
