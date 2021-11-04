import os


def Settings(**kwargs):  # noqa
    return {'interpreter_path': os.system("which python")}
