# UND-NERSC-Collaboration

## Overview

Research and development of key enabling technologies in the construction of software-defined data center network architecture using VXLAN based BGP EVPN for dynamic workflows in a supercomputing environment.

This repository deploys multivendor lab by using containerlab to spin up a two-tier clos topology using Nokia SR Linux and Arista cEOS. BGP is configured in the underlay and for border connections. eBGP is used to emulate the wide area network cloud. Underlay and overlay network uses BGP. This is work in progress.

## Features

*   Automated Deployment: Automates the setup of complex, multi-vendor network topologies using Containerlab.
*   Multi-Vendor Support: Integrates Linux, Nokia SR Linux, and Arista cEOS network operating systems.
*   VXLAN/BGP EVPN: Implements a modern network virtualization architecture using VXLAN for overlay and BGP EVPN for control plane.
*   Stretched CLOS Topology: Creates a scalable and resilient network fabric based on the CLOS architecture.
*   Programmability: Exposes a programmable environment for network configuration and testing.
*   Demonstrates a VXLAN based BGP EVPN design for workflows spanning across multiple domains.

## Getting Started

### Prerequisites

*   Ubuntu version 20.04.6 LTS or higher.
*   Containerlab version 0.64.0 or higher.
*   Docker Engine installed and running (version 27.2.0 or higher). Automatically installed by step 1.
*   Nokia SR Linux network operating system version 24.10.1. Automatically imported by step 2.
*   Linux network multi-tool version 0.2.0 or higher. Automatically imported by step 2.
*   Arista cEOS version 4.32.4M. Requires guest user registeration, license agreement acceptance cEOS download from https://www.arista.com/en/support/software-download

### Installation

Containerlab easily helps deploy the topology by defining all interlinks and node specific information in one YAML file. This file can be used to deploy our topology by passing it as an argument with the deploy command.

1.  Install Containerlab:
      *   Sudo privileges needed to run containerlab.
      *   Quick setup installs docker, Containerlab and gh (CLI tool) in one go.
      *   Script has been tested on Ubuntu 20.04

    ```
    sudo curl -sL https://containerlab.dev/setup | sudo -E bash -s "all"
    ```

### Usage

1.  Clone the repository:

    ```
    git clone https://github.com/ron-nersc/UND-NERSC-Collaboration.git
    cd containerlab-UND-NERSC-Collaboration
    ```

2.  Docker import Arista cEOS-lab-4.32.4M.tar.xz EOS downloaded from prerequisites:

    ```
    sudo docker import cEOS-lab-4.32.4M.tar.xz ceos:4.32.4M
    ```

3.  Deploy the topology:

    ```
    sudo containerlab deploy -t UND-NERSC-Research-1.clab.yml
    ```

### Topology Interaction

<img src="images/UND-NERSC-Lab-Design-V1.0.png" width="750" />

*   The topology has a Primary Compute Site, Backup Compute Site and UND site. Primary and Backup Compute sites model a scalable scientific computing facility while UND site models a remote data streaming site, such as University of North Dakota research department.
*   Data center Interconnect models layer 2 evpn service and connects the Primary and Backup Compute sites.
*   The Wide Area Network (WAN) connects all the sites via eBGP AS 65000 and advertises prefixes between the sites.
*   Primary Compute site advertises Compute subnet 10.10.4.0/22 and Stretched Resource subnet 10.10.8.0/24 to the WAN. These subnets are stretched between the Primary Compute site and Backup Compute site, and are always preferred via the Primary site. Primary Compute site border routers are in BGP AS 65110, spines in BGP AS 65100 and leaves in BGP AS 65050. Primary Compute site has 4 Compute nodes, 2 Stretched Resource nodes, a telemtery stack with gnmic, prometheus, grafana, and a consensus-as-a-service node.
*   Backup Compute site advertises Compute subnet 10.10.4.0/22 and Stretched Resource subnet 10.10.8.0/24 to the WAN. These subnets are always preferred via the Primary Compute site, however, if the Primary Compute site is unavailable then traffic flows to the Backup Compute site. Backup site border routers are in BGP AS 65160, spines in BGP AS 65150 and leaves in BGP AS 65050. Backup COMpute site has 2 Compute nodes, 2 Stretched Resource nodes, and a consensus-as-a-service node.
*   UND Research site has 6 streaming hosts and the gateway is in BGP AS 65170. 
*   Primary Compute site containers: 
       *   primary-evpn-leaf-1, primary-evpn-leaf-2 and primary-evpn-spine-1 are running cEOS.
       *   primary-evpn-leaf-3, primary-evpn-leaf-4, primary-evpn-spine-2, primary-border-1 and primary-border-2 are runing SR Linux.
       *   primary-compute-1 to 4, primary-stretchedresource-1 to 2, telemetry stack and primary-consensus-as-a-service-1 are running Linux.
*   Backup Compute site containers: 
       *   backup-evpn-leaf-1 and backup-evpn-spine-1 are running cEOS.
       *   backup-border-1 is runing SR Linux.
       *   backup-compute-5 to 6, backup-stretchedresource-3 to 4 and backup-consensus-as-a-service-2 are running Linux.       
*   Data center Interconnect container: 
       *   datacenter-interconnect is running cEOS and provides layer 2 connectivity to the spines in Primary and Backup sites.
*   UND Research site containers: 
       *   und-streaming-host-1 to 6 are running Linux.
       *   und-gateway is running cEOS.       
*   Wide Area Network container: 
       *   wan-cloud is running cEOS.


1.  Interacting with the deployed topology.

    > Connect to the `leaf1` node via SSH: `docker exec -it clab-my_topology-leaf1 bash`
    >
    > Verify BGP peering: `"show bgp summary"`




# Lab Lifecycle

Containerlab easily helps deploy the topology by defining all interlinks and node specific information in one YAML file. This file can be used to deploy our topology by passing it as an argument with the deploy command.

clab deploy -t Research-01.clab.yml

Same goes for destroying the lab.

clab destroy -t Research-01.clab.yml

# Accessing the network elements

After deploying the lab, a summary of the deployed nodes in a table like format will be shown. To access a network element with SSH simply use the hostname as described in the table.

ssh admin@primary-border-1

The Linux client uses Almquist Shell can be accessed as regular containers and can be connected to just like to any other container.

sudo docker exec -it alpine /bin/ash

# Telemtery 
Pending