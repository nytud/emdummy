# `emdummy`

A template module for getting started
writing an [`xtsv`](https://github.com/nytud/xtsv) module.

The demo task what this module solves is the following:
 * take the value of the `form` field;
 * create a new field called `star` which will contain the value of the `form` field together with an added asterisk on both sides.

E.g. if the `form` field is `kutya` the `star` field will be `*kutya*`.\
It is also demonstrated that the order of the columns does _not_ affect the operation of `xtsv`.

# Content howto

1. Create your module as a new repo based on this template repo, name it `emNAME`.\
   Change all `dummy/Dummy` occurrences to `NAME` with appropriate letter casing in all files in [`emdummy`](emdummy), [`Makefile`](Makefile) and [`setup.py`](setup.py).\
   Set also author etc. in the latter.\
   In mind, replace `dummy` with `NAME` everywhere in the rest of this document.
2. Set `source_fields` (names of fields your module uses as input) and `target_fields` (names of fields your module adds) in [`emdummy/__main__.py`](emdummy/__main__.py).
3. See comments in [`emdummy/emdummy.py`](emdummy/emdummy.py) for further information.
4. Write a brand new `README.md`.

# Technical howto

## Python package creation

Just type `make` to run all the following.

1. A virtual environment is created in `venv`.
2. `emdummy` Python package is created in `dist/emdummy-*-py3-none-any.whl`.
3. The package is installed in `venv`. 
4. The package is unit tested on `tests/inputs/*.in` and outputs are compared with `tests/outputs/*.out`.

The above steps can be performed separately by `make venv`, `make build`, `make install` and `make test` respectively.

The created Python package can be installed anywhere by direct path:
```bash
pip install ./dist/emdummy-*-py3-none-any.whl
```

## Python package release

1. Check [`emdummy/version.py`](emdummy/version.py). Before your _very first_ release, set `__version__ = '0.0.0'`.
2. `make release-major` or `make release-minor` or `make release-patch`. If in doubt, [read about semantic versoning](https://semver.org).\
   This will update the version number appropriately and make a `git commit` with a new `git` TAG.
3. `make` to recreate the package with the new tag in `dist/emdummy-TAG-py3-none-any.whl`.
4. Go to `https://github.com/THISUSER/emdummy` and _"Create release from tag"_.
5. Add wheel file from `dist/emdummy-TAG-py3-none-any.whl` manually to the release.

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
