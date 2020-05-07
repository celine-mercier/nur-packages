{ stdenv, fetchurl, python3Packages, cmake, python3, bash }:

let
  pythonPackages = python3Packages;
in

pythonPackages.buildPythonApplication rec {
  pname = "obitools3";
  version = "3.0.0-beta16";

  src = fetchurl {
    url = "https://git.metabarcoding.org/obitools/${pname}/repository/v${version}/archive.tar.gz";
    sha256 = "33052cea83000bcbae7d32407e16b09c2036213a2c91cd52c0329e26577dd6b4";
  };

  preBuild = ''
    substituteInPlace src/CMakeLists.txt --replace \$'{PYTHONLIB}' "$out/lib/${python3.libPrefix}/site-packages";
    export NIX_CFLAGS_COMPILE="-L $out/lib/${python3.libPrefix}/site-packages $NIX_CFLAGS_COMPILE"
  '';

  disabled = !pythonPackages.isPy3k;

  nativeBuildInputs = [ pythonPackages.cython cmake ];

  dontConfigure = true;

  doCheck = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib ; {
    description = "Management of analyses and data in DNA metabarcoding";
    homepage = "https://git.metabarcoding.org/obitools/obitools3";
    license = licenses.cecill20;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.all;
  };
}
