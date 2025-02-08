# UND-NERSC-Collaboration
Research and development of key enabling technologies in the construction of software-defined data center network architecture using VXLAN based BGP EVPN for dynamic workflows in a supercomputing environment.

This repository deploys multivendor lab by using containerlab to spin up a two-tier clos topology using Nokia SR Linux and Arista cEOS. BGP is configured in the underlay and for border connections. OSPF is used to emulate the wide area network cloud. Currenty, the underlay is being built. This is work in progress.

# Lab Lifecycle

Containerlab easily helps deploy the topology by defining all interlinks and node specific information in one YAML file. This file can be used to deploy our topology by passing it as an argument with the deploy command.

clab deploy -t Research-01.clab.yml

Same goes for destroying the lab

clab destroy -t Research-01.clab.yml

# Accessing the network elements

After deploying the lab, a summary of the deployed nodes in a table like format will be shown. To access a network element with SSH simply use the hostname as described in the table.

ssh admin@primary-border-1

The Linux client uses Almquist Shell can be accessed as regular containers and can be connected to just like to any other container.

sudo docker exec -it alpine /bin/ash

