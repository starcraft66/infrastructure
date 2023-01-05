import re
import yaml
from pathlib import Path
def _load_yaml():
    extraConfigBase = Path('/run/config/extra')
    configFiles = [Path('/run/config/netbox/netbox.yaml')]
    configFiles.extend(sorted(extraConfigBase.glob('*/*.yaml')))
    for configFile in configFiles:
        with open(configFile, 'r') as f:
            config = yaml.safe_load(f)
    globals().update(config)
def _load_secret(name, key):
    path = "/run/secrets/{name}/{key}".format(name=name, key=key)
    with open(path, 'r') as f:
        return f.read()
_load_yaml()
DATABASE['PASSWORD'] = _load_secret('netbox', 'db_password')
EMAIL['PASSWORD'] = _load_secret('netbox', 'email_password')
NAPALM_PASSWORD = _load_secret('netbox', 'napalm_password')
REDIS['tasks']['PASSWORD'] = _load_secret('netbox', 'redis_tasks_password')
REDIS['caching']['PASSWORD'] = _load_secret('netbox', 'redis_cache_password')
SECRET_KEY = _load_secret('netbox', 'secret_key')
# Post-process certain values
CORS_ORIGIN_REGEX_WHITELIST = [re.compile(r) for r
                                in CORS_ORIGIN_REGEX_WHITELIST]
