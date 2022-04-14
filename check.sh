echo "Get ubuntu base image..."
docker pull ubuntu:18.04
echo "Building SGX sample container (entrypoint: java -version)..."
docker build -t java-sample -f ./test/ubuntu18.04-openjdk-11.dockerfile . --build-arg http_proxy=http://proxy-mu.intel.com:911 --build-arg https_proxy=http://proxy-mu.intel.com:912
echo "Run ungraminized Java sample container..."
echo "________________________________________________"
docker run --rm --name java_sample java-sample
echo "________________________________________________"
echo "Make sure output above shows java version indeed"
sleep 5
docker rmi gsc-java-sample --force
./gsc build java-sample test/generic.manifest  --build-arg http_proxy=http://proxy-mu.intel.com:911 --build-arg https_proxy=http://proxy-mu.intel.com:912
openssl genrsa -3 -out enclave-key.pem 3072
./gsc sign-image java-sample enclave-key.pem
./gsc info-image gsc-java-sample
echo "Running graminized container..."
docker run --device=/dev/sgx_enclave -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket -it --rm --name gsc_java_sample gsc-java-sample