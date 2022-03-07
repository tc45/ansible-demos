#!/usr/bin/env python


class FilterModule(object):
    def filters(self):
        return {
            "port_description": self.port_description,
        }

    def port_description(self, facts):
        port_configs = []
        for port in facts["ansible_facts"]["ansible_net_neighbors"]:
            port_configs.append(
                {
                    "name": facts["ansible_facts"]["ansible_net_neighbors"][port][0][
                        "port"
                    ],
                    "connected_device": facts["ansible_facts"]["ansible_net_neighbors"][
                        port
                    ][0]["sysname"],
                }
            )
        return port_configs
