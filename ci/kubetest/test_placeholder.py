import pytest


@pytest.fixture
def setup(kube):
    pass


def test_something(setup, kube):
    assert True == True
