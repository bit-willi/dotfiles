#/bin/env bash

curl -sSL https://raw.githubusercontent.com/bschnurr/python-type-stubs/add-opencv/cv2/__init__.pyi \
	-o $(python -c 'import cv2, os; print(os.path.dirname(cv2.__file__))')
