from __future__ import annotations
import re
from typing import Any
from checkov.common.models.enums import CheckResult, CheckCategories
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck

class InstancePlatformId(BaseResourceCheck):
    def __init__(self) -> None:
        name = "Ensure compute instance use modern cpu"
        id = "CKV_YC_1444"
        categories= (CheckCategories.SUPPLY_CHAIN,)
        supported_resources = ("yandex_compute_instance", "yandex_mdb_redis_cluster")
        super().__init__(
            name=name,
            id=id,
            categories=categories,
            supported_resources=supported_resources,
        )

    def scan_resource_conf(self, conf: dict[str, list[Any]]) -> CheckResult:
        if self.entity_type == "yandex_compute_instance":
            if "platform_id" in conf.keys():
                platform_id = conf["platform_id"]
                if platform_id == ["standard-v3"]:
                    return CheckResult.PASSED
                return CheckResult.FAILED
        elif self.entity_type == "yandex_mdb_redis_cluster":
            if "resources" in conf.keys():
                resource_preset_id = conf["resources"][0]["resource_preset_id"][0]
                if re.match('^(b|hm)3-.+',resource_preset_id):
                    return CheckResult.PASSED
                return CheckResult.FAILED

check = InstancePlatformId()
