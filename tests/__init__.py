import pathlib

import dotenv


THIS = pathlib.Path(__file__).resolve()
ENV_FILE_NAME = ".env"
ENV_FILE_PATH = THIS.parents[1] / ENV_FILE_NAME


dotenv.load_dotenv(ENV_FILE_PATH)
