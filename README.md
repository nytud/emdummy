# emDummy
A template module for xtsv

Take a look at this toy module for getting started
writing an [`xtsv`](https://github.com/nytud/xtsv) module.

This module is for educational purposes.
It solves an extremely simple task:
 * takes the value of the `form` field;
 * create a new field called `star` which will contain the value of the `form` field together with an added asterisk on both sides.

E.g. if the `form` field is `kutya` the `star` field will be `*kutya*`.

It is demonstrated that the order of the columns does _not_ affect the operation of `xtsv`.

## Python package creation

[_Poetry_](https://python-poetry.org/) and (optionally) [_GNU Make_](https://www.gnu.org/software/make/) are required.

1. `git clone https://github.com/REPO_NAME.git`
2. Run `make`

On Windows or without Make (after cloning the repository):

1. `poetry install --no-root`
2. `poetry build`
3. `poetry run pip install --upgrade dist/*.whl` (the correct filename must be specified on Windows)

(optional) To install extras run: `poetry install -E [NAME OF THE EXTRA TO INSTALL]`

By executing

```bash
make
```

1. a virtual environment is created;
2. `emdummy` Python package is created
in `dist/emdummy-*-py3-none-any.whl`;
3. the package is installed in the virtualenv;
4. the package is tested (see [__testing__](#testing)).

The Python package can be installed anywhere by direct path:

```bash
pip install path/to/emdummy-*-py3-none-any.whl
```

## Testing

After the Python package is ready:

```bash
make test
```

runs `emdummy` on `tests/input/*.tsv`
and compares the output with `tests/gold/*.tsv`.

## Setting up CI/CD environment

See information in [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)
