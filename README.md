# `emdummy`

A template module for xtsv

Take a look at this toy module for getting started
writing an [`xtsv`](https://github.com/nytud/xtsv) module.

This module is for educational purposes.
It solves an extremely simple task:
 * takes the value of the `form` field;
 * create a new field called `star` which will contain the value of the `form` field together with an added asterisk on both sides.

E.g. if the `form` field is `kutya` the `star` field will be `*kutya*`.

It is demonstrated that the order of the columns does _not_ affect the operation of `xtsv`.

# Content howto

## Python package creation

[_Poetry_](https://python-poetry.org/) and (optionally) [_GNU Make_](https://www.gnu.org/software/make/) are required.

1. `git clone https://github.com/REPO_NAME.git`
2. Run `make`

On Windows or without Make (after cloning the repository):

1. `poetry install --no-root`
2. `poetry build`
3. `poetry run pip install --upgrade dist/*.whl` (the correct filename must be specified on Windows)

(optional) To install extras run: `poetry install -E [NAME OF THE EXTRA TO INSTALL]`

By executing `make` you run all the following:

1. a virtual environment is created;
2. `emdummy` Python package is created in `dist/emdummy-*-py3-none-any.whl`;
3. the package is installed in the virtualenv;
4. the package is tested (see [__testing__](#testing)).

The above steps can be performed separately by `make venv`, `make build`, `make install` and `make test` respectively.

The Python package can be installed anywhere by direct path:

```bash
pip install path/to/emdummy-*-py3-none-any.whl
```

## Create your own module

1. Create your module as a new repo based on this template repo, name it `emNAME`.\
   Change all `dummy/Dummy` occurrences to `NAME` with appropriate letter casing in all files in [`src/emdummy`](src/emdummy), [`Makefile`](Makefile) and [`pyproject.toml`](pyproject.toml). \
   Set also author etc. in the latter. \
   In mind, replace `dummy` with `NAME` everywhere in the rest of this document.
2. Set `source_fields` (names of fields your module uses as input) and `target_fields` (names of fields your module adds) in [`src/emdummy/__main__.py`](src/emdummy/__main__.py).
3. See comments in [`src/emdummy/emdummy.py`](src/emdummy/emdummy.py) for further information.
4. Write a brand new `README.md`.

## Testing

After the Python package is ready:

```bash
make test
```

runs `emdummy` on `tests/input/*.tsv`
and compares the output with `tests/gold/*.tsv`.

## Setting up CI/CD environment

See information in [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)

1. Check [`pyproject.toml`](pyproject.toml). Before your _very first_ release, set `version = "0.0.0"`.
2. `make release-major` or `make release-minor` or `make release-patch`. If in doubt, [read about semantic versoning](https://semver.org).
This will (if [CI/CD has been set up correctly](#setting up CI-CD-environment))
   - Update the version number appropriately
   - Make a `git commit`
   - Make a `git` TAG
   - Release the package on github
   - Upload a new pypi package

## Add the released package to `emtsv`

1. Install [`emtsv`](https://github.com/nytud/emtsv/blob/master/docs/installation.md): 1st and 2nd point + `cython` only.
2. Go to the `emtsv` directory (`cd emtsv`).
3. Add `emdummy` by adding this line to [`requirements.txt`](https://github.com/nytud/emtsv/blob/master/requirements.txt):\
   `https://github.com/THISUSER/emdummy/releases/download/vTAG/emdummy-TAG-py3-none-any.whl`
4. Complete [`config.py`](https://github.com/nytud/emtsv/blob/master/config.py) by adding `em_dummy` and `tools` from [`emdummy/__main__.py`](emdummy/__main__.py) appropriately.
5. Complete `emtsv` installation by `make venv`.
6. `echo "A kutya ment volna el sétálni." | venv/bin/python3 ./main.py tok,morph,pos > old`
7. `echo "A kutya ment volna el sétálni." | venv/bin/python3 ./main.py tok,morph,pos,dummy > new`
8. See results e.g. by `diff old new`.
9. If everything is in order, create a PR for `emtsv`.

That's it! :)
