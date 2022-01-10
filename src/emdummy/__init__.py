#!/usr/bin/env python3
# -*- coding: utf-8, vim: expandtab:ts=4 -*-

from .emdummy import EmDummy
from .version import __version__
from .__main__ import entrypoint

__all__ = [EmDummy.__name__, __version__, entrypoint]
