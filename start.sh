mkdir actions-runner && cd actions-runner
curl -O -L https://github.com/actions/runner/releases/download/v2.273.5/actions-runner-linux-x64-2.273.5.tar.gz
tar xzf ./actions-runner-linux-x64-2.273.5.tar.gz

# TODO Replace this
# ./config.sh --url URLHERE --token TOKENHERE

./run.sh
