# ProxMoxLXC Container Creator

A shell script to automate the creation of LXC containers in a Proxmox environment using the Proxmox API.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [How it works](#how-it-works)

## Features

- **Automated VMID Generation:** Generates a random VMID and checks for its availability.
- **Proxmox API Integration:** Communicates with the Proxmox API to manage containers.
- **Easy Configuration:** Utilizes a `.env` file for managing sensitive credentials.

## Prerequisites

- **API Token & Secret:** Generated from your Proxmox VE instance with appropriate permissions.
- **jq:** A lightweight and flexible command-line JSON processor.
- **curl:** Command-line tool for transferring data with URLs.
- **shuf:** Command-line utility that shuffles the lines of a file.

## Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/FaureAlexis/proxmox-lxc-automation.git
   cd proxmox-lxc-automation
   ```

2. **Make the Script Executable:**

   ```bash
   chmod +x script.sh
   ```

## Configuration

Create a `.env` file in the root directory of the project to store your configuration variables:

```bash
API_NODE=your api node
API_TOKEN=your api token
API_SECRET=your api secret
TARGET_NODE=your target node (where to create lxc container)
```

## Usage

```bash
./script.sh
```

## How it works

The script will create a new container with a random VMID, using the OS template `local-hdd-templates:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst`, in the storage pool `ASD-202410`, with a network interface connected to the `vmbr2` bridge, with 1 CPU core and a root filesystem of 8GB.
