<div align="center">
  <h1>Alexandria</h1>
  <img src="docs/images/logo.png" height="400" width="400">
  <br />
  <a href="https://github.com/keep-starknet-strange/alexandria/issues/new?assignees=&labels=bug&template=01_BUG_REPORT.md&title=bug%3A+">Report a Bug</a>
  -
  <a href="https://github.com/keep-starknet-strange/alexandria/issues/new?assignees=&labels=enhancement&template=02_FEATURE_REQUEST.md&title=feat%3A+">Request a Feature</a>
  -
  <a href="https://github.com/keep-starknet-strange/alexandria/discussions">Ask a Question</a>
</div>

<div align="center">
<br />

[![GitHub Workflow Status](https://github.com/keep-starknet-strange/alexandria/actions/workflows/test.yml/badge.svg)](https://github.com/keep-starknet-strange/alexandria/actions/workflows/test.yml)
[![Project license](https://img.shields.io/github/license/keep-starknet-strange/alexandria.svg?style=flat-square)](LICENSE)
[![Pull Requests welcome](https://img.shields.io/badge/PRs-welcome-ff69b4.svg?style=flat-square)](https://github.com/keep-starknet-strange/alexandria/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)

</div>

<details>
<summary>Table of Contents</summary>

- [Report a Bug](#report-a-bug)
- [Request a Feature](#request-a-feature)
- [About](#about)
- [Features](#features)
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

Alexandria is a community maintained standard library for Cairo 1.0.
It is a collection of useful algorithms and data structures implemented in Cairo.  
Current version: [v2.0.1](https://github.com/starkware-libs/cairo/releases/tag/v2.0.1)

## Features

This repository is divided in 8 modules:

- [Data Structures](./src/data_structures/README.md)
- [Encoding](./src/encoding/README.md)
- [Linalg](./src/linalg/README.md)
- [Math](./src/math/README.md)
- [Numeric](./src/numeric/README.md)
- [Searching](./src/searching/README.md)
- [Sorting](./src/sorting/README.md)
- [Storage](./src/storage/README.md)

## Getting Started

### Prerequisites

- [Cairo](https://github.com/starkware-libs/cairo)
- [Scarb](https://docs.swmansion.com/scarb)
- [Rust](https://www.rust-lang.org/tools/install)

### Installation

Alexandria is a collection of cairo utilities, which can be installed by adding the following line to your `Scarb.toml`:

```toml
[dependencies]
alexandria = { git = "https://github.com/keep-starknet-strange/alexandria.git" }
```

then add the following line in your `.cairo` file

```rust
use alexandria::math::sha512::sha512;
```

## Usage

### Build

```bash
scarb build
```

### Test

```bash
scarb test
```
Running a specific subset of tests 
```bash
scarb test -f math
```

### Format

```bash
scarb fmt
```

## Roadmap

See the [open issues](https://github.com/keep-starknet-strange/alexandria/issues) for a list of proposed features (and known issues).

- [Top Feature Requests](https://github.com/keep-starknet-strange/alexandria/issues?q=label%3Aenhancement+is%3Aopen+sort%3Areactions-%2B1-desc) (Add your votes using the 👍 reaction)
- [Top Bugs](https://github.com/keep-starknet-strange/alexandria/issues?q=is%3Aissue+is%3Aopen+label%3Abug+sort%3Areactions-%2B1-desc) (Add your votes using the 👍 reaction)
- [Newest Bugs](https://github.com/keep-starknet-strange/alexandria/issues?q=is%3Aopen+is%3Aissue+label%3Abug)

## Support

Reach out to the maintainer at one of the following places:

- [GitHub Discussions](https://github.com/keep-starknet-strange/alexandria/discussions)
- Contact options listed on [this GitHub profile](https://github.com/starknet-exploration)

## Project assistance

If you want to say **thank you** or/and support active development of Alexandria:

- Add a [GitHub Star](https://github.com/keep-starknet-strange/alexandria) to the project.
- Tweet about the Alexandria.
- Write interesting articles about the project on [Dev.to](https://dev.to/), [Medium](https://medium.com/) or your personal blog.

Together, we can make Alexandria **better**!

## Contributing

First off, thanks for taking the time to contribute! Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make will benefit everybody else and are **greatly appreciated**.

Please read [our contribution guidelines](docs/CONTRIBUTING.md), and thank you for being involved!

## Authors & contributors

For a full list of all authors and contributors, see [the contributors page](https://github.com/keep-starknet-strange/alexandria/contributors).

## Security

Alexandria follows good practices of security, but 100% security cannot be assured.
Alexandria is provided **"as is"** without any **warranty**. Use at your own risk.

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
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/abdelhamidbakhta"><img src="https://avatars.githubusercontent.com/u/45264458?v=4?s=100" width="100px;" alt="Abdel @ StarkWare "/><br /><sub><b>Abdel @ StarkWare </b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=abdelhamidbakhta" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/sdgalvan"><img src="https://avatars.githubusercontent.com/u/58611754?v=4?s=100" width="100px;" alt="Santiago Galván (Dub)"/><br /><sub><b>Santiago Galván (Dub)</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=sdgalvan" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/dpinones"><img src="https://avatars.githubusercontent.com/u/30808181?v=4?s=100" width="100px;" alt="Damián Piñones"/><br /><sub><b>Damián Piñones</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=dpinones" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/greged93"><img src="https://avatars.githubusercontent.com/u/82421016?v=4?s=100" width="100px;" alt="greged93"/><br /><sub><b>greged93</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=greged93" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/mkaput"><img src="https://avatars.githubusercontent.com/u/3450050?v=4?s=100" width="100px;" alt="Marek Kaput"/><br /><sub><b>Marek Kaput</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=mkaput" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/amanusk"><img src="https://avatars.githubusercontent.com/u/7280933?v=4?s=100" width="100px;" alt="amanusk"/><br /><sub><b>amanusk</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=amanusk" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/msaug"><img src="https://avatars.githubusercontent.com/u/60658558?v=4?s=100" width="100px;" alt="Mathieu"/><br /><sub><b>Mathieu</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=msaug" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/EvolveArt"><img src="https://avatars.githubusercontent.com/u/12902455?v=4?s=100" width="100px;" alt="0xevolve"/><br /><sub><b>0xevolve</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=EvolveArt" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/JordyRo1"><img src="https://avatars.githubusercontent.com/u/87231934?v=4?s=100" width="100px;" alt="Jordy Romuald"/><br /><sub><b>Jordy Romuald</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=JordyRo1" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/gaetbout"><img src="https://avatars.githubusercontent.com/u/16206518?v=4?s=100" width="100px;" alt="gaetbout"/><br /><sub><b>gaetbout</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=gaetbout" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/LucasLvy"><img src="https://avatars.githubusercontent.com/u/70894690?v=4?s=100" width="100px;" alt="Lucas @ StarkWare"/><br /><sub><b>Lucas @ StarkWare</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=LucasLvy" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://milancermak.com/"><img src="https://avatars.githubusercontent.com/u/184055?v=4?s=100" width="100px;" alt="Milan Cermak"/><br /><sub><b>Milan Cermak</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=milancermak" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/neotheprogramist"><img src="https://avatars.githubusercontent.com/u/128649481?v=4?s=100" width="100px;" alt="Paweł"/><br /><sub><b>Paweł</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=neotheprogramist" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/tensojka"><img src="https://avatars.githubusercontent.com/u/8470346?v=4?s=100" width="100px;" alt="Ondřej Sojka"/><br /><sub><b>Ondřej Sojka</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/alexandria/commits?author=tensojka" title="Code">💻</a></td>
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

[scarb]: https://github.com/software-mansion/scarb
