import json
import os
import re
from pathlib import Path

import yaml


def _deep_merge(source, destination):
    for key, value in source.items():
        destination_value = destination.get(key)
        if isinstance(value, dict) and isinstance(destination_value, dict):
            _deep_merge(value, destination_value)
        else:
            destination[key] = value


def _load_yaml():
    config_files = [Path("/run/config/netbox/netbox.yaml")]
    config_files.extend(sorted(Path("/run/config/extra").glob("*/*.yaml")))
    for config_file in config_files:
        with open(config_file, "r", encoding="utf-8") as config_handle:
            _deep_merge(yaml.safe_load(config_handle), globals())


def _read_secret(secret_name, secret_key):
    try:
        with open(
            f"/run/secrets/{secret_name}/{secret_key}",
            "r",
            encoding="utf-8",
        ) as secret_handle:
            return secret_handle.read().strip()
    except OSError:
        return None


CORS_ORIGIN_REGEX_WHITELIST = []
DATABASES = {}
EMAIL = {}
REDIS = {}
_load_yaml()

provided_secret_name = os.getenv("SECRET_NAME", "netbox")
DATABASES["default"]["PASSWORD"] = _read_secret(provided_secret_name, "db_password")
EMAIL["PASSWORD"] = _read_secret(provided_secret_name, "email_password")
REDIS["tasks"]["PASSWORD"] = _read_secret(provided_secret_name, "tasks_password")
REDIS["caching"]["PASSWORD"] = _read_secret(provided_secret_name, "cache_password")
NAPALM_PASSWORD = _read_secret(provided_secret_name, "napalm_password")
SECRET_KEY = _read_secret(provided_secret_name, "secret_key")

_peppers_raw = _read_secret(provided_secret_name, "api_token_peppers")
if _peppers_raw:
    API_TOKEN_PEPPERS = {int(key): value for key, value in json.loads(_peppers_raw).items()}

CORS_ORIGIN_REGEX_WHITELIST = [re.compile(value) for value in CORS_ORIGIN_REGEX_WHITELIST]
if "SENTINELS" in REDIS["tasks"]:
    REDIS["tasks"]["SENTINELS"] = [tuple(value.split(":")) for value in REDIS["tasks"]["SENTINELS"]]
if "SENTINELS" in REDIS["caching"]:
    REDIS["caching"]["SENTINELS"] = [tuple(value.split(":")) for value in REDIS["caching"]["SENTINELS"]]
