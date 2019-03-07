# bitbucket_code_coverage

[![Build Status](https://travis-ci.org/arturdm/bitbucket_code_coverage.svg?branch=master)](https://travis-ci.org/arturdm/bitbucket_code_coverage)
[![codecov](https://codecov.io/gh/arturdm/bitbucket_code_coverage/branch/master/graph/badge.svg)](https://codecov.io/gh/arturdm/bitbucket_code_coverage)

Converts coverage data from LCOV and publishes to Bitbucket server with
[plugin](https://bitbucket.org/atlassian/bitbucket-code-coverage) installed.

## Usage

Add `bitbucket_code_coverage` to `dev_dependencies`.

```yaml
dev_dependencies:
  bitbucket_code_coverage: ^0.0.1
```

Run the executable.

```bash
pub run bitbucket_code_coverage \
  --url http://localhost:7990 \
  -t TOKEN \
  -u USERNAME \
  -p PASSWORD \
  post \
  -c COMMIT_ID \
  -f LCOV_FILE \
  -d WORKING_DIRECTORY \
  --file-pattern **/lcov.info
```
