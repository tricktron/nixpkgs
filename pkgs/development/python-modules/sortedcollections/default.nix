{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytestCheckHook,
  sortedcontainers,
}:

buildPythonPackage rec {
  pname = "sortedcollections";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "grantjenks";
    repo = "python-sortedcollections";
    tag = "v${version}";
    hash = "sha256-GkZO8afUAgDpDjIa3dhO6nxykqrljeKldunKMODSXfg=";
  };

  propagatedBuildInputs = [ sortedcontainers ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sortedcollections" ];

  meta = with lib; {
    description = "Python Sorted Collections";
    homepage = "http://www.grantjenks.com/docs/sortedcollections/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
