{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-access-context-manager,
  google-cloud-org-policy,
  google-cloud-os-config,
  google-cloud-testutils,
  grpc-google-iam-v1,
  libcst,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-asset";
  version = "3.30.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_asset";
    inherit version;
    hash = "sha256-oPAkm/y8RO9/iYC2IUJN58/ilYjS2skMtYzMyBDQU8w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    grpc-google-iam-v1
    google-api-core
    google-cloud-access-context-manager
    google-cloud-org-policy
    google-cloud-os-config
    libcst
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  optional-dependencies = {
    libcst = [ libcst ];
  };

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.asset"
    "google.cloud.asset_v1"
    "google.cloud.asset_v1p1beta1"
    "google.cloud.asset_v1p2beta1"
    "google.cloud.asset_v1p4beta1"
    "google.cloud.asset_v1p5beta1"
  ];

  meta = with lib; {
    description = "Python Client for Google Cloud Asset API";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-asset";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-asset-v${version}/packages/google-cloud-asset/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
