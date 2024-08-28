#!/bin/bash
set -e

# Run your tests here
python -m unittest discover tests

# Generate XML report
python -m xmlrunner discover tests --output-file test-results/results.xml
