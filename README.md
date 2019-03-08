# bitbucket_code_coverage

[![Build Status](https://travis-ci.org/arturdm/bitbucket_code_coverage.svg?branch=master)](https://travis-ci.org/arturdm/bitbucket_code_coverage)
[![codecov](https://codecov.io/gh/arturdm/bitbucket_code_coverage/branch/master/graph/badge.svg)](https://codecov.io/gh/arturdm/bitbucket_code_coverage)

Converts coverage data from LCOV and publishes to Bitbucket server with
[Bitbucket Server Code Coverage Plugin] installed.

## Usage

Add `bitbucket_code_coverage` to `dev_dependencies`.

```yaml
dev_dependencies:
  bitbucket_code_coverage: ^0.0.1
```

Run the executable for a single coverage file.

```bash
pub run bitbucket_code_coverage \
  --url http://localhost:7990 \
  -u <username> \
  -p <password> \
  post \
  -c <commit_id> \
  -f build/lcov.info
```

In order to publish data from multiple coverage files use `--file-pattern` option. If you would 
like to use [Personal Access Token] you can do so by passing it to `-t` option.

```bash
pub run bitbucket_code_coverage \
    --url http://localhost:7990 \
    -t <personal_access_token> \
    post \
    -c <commit_id> \
    --file-pattern **/lcov.info
```

[Bitbucket Server Code Coverage Plugin]: https://bitbucket.org/atlassian/bitbucket-code-coverage
[Personal Access Token]: https://confluence.atlassian.com/bitbucketserver/personal-access-tokens-939515499.html
