{ lib, buildPythonPackage, fetchPypi, python, isPy27
, attrs
, functools32
, importlib-metadata
, pyrsistent
, setuptools-scm
, twisted
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ attrs importlib-metadata functools32 pyrsistent ];
  checkInputs = [ pytestCheckHook twisted ];
  pytestFlagsArray = [ "jsonschema/tests" ];
  disabledTests = [
    # network
    "retrieves_local_refs_via_urlopen"
  ];

  # zope namespace collides on py27
  doCheck = !isPy27;

  meta = with lib; {
    homepage = "https://github.com/Julian/jsonschema";
    description = "An implementation of JSON Schema validation for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
