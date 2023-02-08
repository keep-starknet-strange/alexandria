<div align="center">
  <h1>Quaireaux</h1>
  <img src="docs/images/logo.png" height="400" width="400">
  <br />
  <a href="https://github.com/stark-rocket/quaireaux/issues/new?assignees=&labels=bug&template=01_BUG_REPORT.md&title=bug%3A+">Report a Bug</a>
  -
  <a href="https://github.com/stark-rocket/quaireaux/issues/new?assignees=&labels=enhancement&template=02_FEATURE_REQUEST.md&title=feat%3A+">Request a Feature</a>
  -
  <a href="https://github.com/stark-rocket/quaireaux/discussions">Ask a Question</a>
</div>

<div align="center">
<br />

[![GitHub Workflow Status](https://github.com/stark-rocket/quaireaux/actions/workflows/test.yml/badge.svg)](https://github.com/stark-rocket/quaireaux/actions/workflows/test.yml)
[![Project license](https://img.shields.io/github/license/stark-rocket/quaireaux.svg?style=flat-square)](LICENSE)
[![Pull Requests welcome](https://img.shields.io/badge/PRs-welcome-ff69b4.svg?style=flat-square)](https://github.com/stark-rocket/quaireaux/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)

</div>

<details>
<summary>Table of Contents</summary>

- [Report a Bug](#report-a-bug)
- [Request a Feature](#request-a-feature)
- [About](#about)
- [Features](#features)
  - [Data Structures](#data-structures)
  - [Math](#math)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
  - [Build](#build)
  - [Run](#run)
  - [Test](#test)
  - [Format](#format)
- [Roadmap](#roadmap)
- [Support](#support)
- [Project assistance](#project-assistance)
- [Contributing](#contributing)
- [Authors \& contributors](#authors--contributors)
- [Security](#security)
- [License](#license)
- [Acknowledgements](#acknowledgements)
- [Contributors ✨](#contributors-)

</details>

---

## About

Quaireaux is a community maintained standard library for Cairo 1.0.
It is a collection of useful algorithms and data structures implemented in Cairo.

## Features

### Data Structures

- [x] [Merkle Tree](src/data_structures/merkle_tree.cairo)
- [x] [Queue](src/data_structures/queue.cairo)

### Math

- [x] [Fibonacci](src/math/sequence/fibonacci.cairo)
- [x] [Zeller's congruence](src/math/zellers_congruence.cairo)
- [x] [Extended Euclidean Algorithm](src/math/extended_euclidean_algorithm.cairo) 
- [x] [Karatsuba Multiplication Algorithm](src/math/karatsuba.cairo) 
## Getting Started

### Prerequisites

- [Cairo](https://github.com/starkware-libs/cairo)
- [Rust](https://www.rust-lang.org/tools/install)

### Installation

> **[TODO]**

## Usage


### Build

```bash
make build
```

### Run

```bash
make run
```

### Test

```bash
make test
```

### Format

```bash
make format
```

## Roadmap

See the [open issues](https://github.com/stark-rocket/quaireaux/issues) for a list of proposed features (and known issues).

- [Top Feature Requests](https://github.com/stark-rocket/quaireaux/issues?q=label%3Aenhancement+is%3Aopen+sort%3Areactions-%2B1-desc) (Add your votes using the 👍 reaction)
- [Top Bugs](https://github.com/stark-rocket/quaireaux/issues?q=is%3Aissue+is%3Aopen+label%3Abug+sort%3Areactions-%2B1-desc) (Add your votes using the 👍 reaction)
- [Newest Bugs](https://github.com/stark-rocket/quaireaux/issues?q=is%3Aopen+is%3Aissue+label%3Abug)

## Support

Reach out to the maintainer at one of the following places:

- [GitHub Discussions](https://github.com/stark-rocket/quaireaux/discussions)
- Contact options listed on [this GitHub profile](https://github.com/starknet-exploration)

## Project assistance

If you want to say **thank you** or/and support active development of Quaireaux:

- Add a [GitHub Star](https://github.com/stark-rocket/quaireaux) to the project.
- Tweet about the Quaireaux.
- Write interesting articles about the project on [Dev.to](https://dev.to/), [Medium](https://medium.com/) or your personal blog.

Together, we can make Quaireaux **better**!

## Contributing

First off, thanks for taking the time to contribute! Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make will benefit everybody else and are **greatly appreciated**.

Please read [our contribution guidelines](docs/CONTRIBUTING.md), and thank you for being involved!

## Authors & contributors

For a full list of all authors and contributors, see [the contributors page](https://github.com/stark-rocket/quaireaux/contributors).

## Security

Quaireaux follows good practices of security, but 100% security cannot be assured.
Quaireaux is provided **"as is"** without any **warranty**. Use at your own risk.

_For more information and to report security issues, please refer to our [security documentation](docs/SECURITY.md)._

## License

This project is licensed under the **MIT license**.

See [LICENSE](LICENSE) for more information.

## Acknowledgements

- [TheAlgorithms/Rust](https://github.com/TheAlgorithms/Rust) for inspiration regarding the implementation of algorithms.

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/abdelhamidbakhta"><img src="https://avatars.githubusercontent.com/u/45264458?v=4?s=100" width="100px;" alt="Abdel @ StarkWare "/><br /><sub><b>Abdel @ StarkWare </b></sub></a><br /><a href="https://github.com/keep-starknet-strange/quaireaux/commits?author=abdelhamidbakhta" title="Code">💻</a></td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <td align="center" size="13px" colspan="7">
        <img src="https://raw.githubusercontent.com/all-contributors/all-contributors-cli/1b8533af435da9854653492b1327a23a4dbd0a10/assets/logo-small.svg">
          <a href="https://all-contributors.js.org/docs/en/bot/usage">Add your contributions</a>
        </img>
      </td>
    </tr>
  </tfoot>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!