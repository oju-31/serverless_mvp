# import pytest
# from unittest.mock import patch
import os
import sys

# Adding backend to sys.path directly
sys.path.append(os.path.abspath('backend/open/login_pkg'))
from login import make_response  # noqa