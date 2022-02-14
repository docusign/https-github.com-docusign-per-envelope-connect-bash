# Per-envelope Connect in embedded signing code example

### GitHub repo: [per-envelope-connect-bash](./README.md)

This GitHub repo contains a single code example that sends an envelope with per-envelope Connect values set in the body.

## Introduction

This repo is based on the [eg001EmbeddedSigning.sh](https://github.com/docusign/code-examples-bash/blob/master/eg001EmbeddedSigning.sh) example in the Bash Code Example repo: [code-examples-bash](https://github.com/docusign/code-examples-bash)

To make it easier to run the example, you can copy the contents of the config directory from a Bash quickstart project.
You can see how to install the Bash Quickstart and run the Embedded Signing Demo watching this video: 

[Bash Quickstart & Embedded Signing Demo](https://youtu.be/CfIX-l8zwvg)

You can use the following authentication methods with this code example:

* Authentication with DocuSign via [Authorization Code Grant](https://developers.docusign.com/platform/auth/authcode).
When the token expires, the user is asked to re-authenticate. The refresh token is not used.

* Authentication with DocuSign via [JSON Web Token (JWT) Grant](https://developers.docusign.com/platform/auth/jwt/).
When the token expires, it updates automatically.

## License and additional information

### License
This repository uses the MIT License. See [LICENSE](./LICENSE) for details.

### Pull Requests
Pull requests are welcomed. Pull requests will only be considered if their content
uses the MIT License.
