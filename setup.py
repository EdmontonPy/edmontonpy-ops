#!/usr/bin/env python3
from os.path import join, dirname

from setuptools import setup

setup(
    name='edmontonpy-ops',
    version='0.0.1',
    author='Andrew Crouse',
    author_email='amcrouse@data-get.org',
    packages=[
    ],
    scripts=[
    ],
    description='Infrastructure for EdmontonPy',
    long_description=open(join(dirname(__file__), 'README.rst')).read(),
    install_requires=[
        'ansible >= 2.7.12, < 3.0.0.0',
    ],
)
