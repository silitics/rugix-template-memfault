# Rugix: Quickstart Template for Memfault

This template showcases how to set up a [Rugix](https://rugix.org) project for use with [Memfault](https://memfault.com/).

## Usage

### Setup

Install [`just`](https://just.systems/man/en/) to be able to use the `Justfile`.

Copy the file `env.template` to `.env` and set the following variables:

- `MEMFAULT_PROJECT_KEY`: Memfault project key for inclusion in the system.
- `DEV_SSH_KEYS`: Public SSH keys for connecting via SSH to the system.

If you want to be able to upload OTA updates, also set the following variables:

- `MEMFAULT_ORG_SLUG`: Slug of your Memfault organization.
- `MEMFAULT_ORG_TOKEN`: Access token for your Memfault organization.
- `MEMFAULT_PROJECT_SLUG`: Project to upload OTA updates to.

### Tasks

#### Running a VM

To run a VM based on the `customized-efi-arm64` system:

```shell
just run
```

#### Connect to VM via SSH

To connect to a running VM via SSH:

```shell
just ssh
```

Note that this requires `DEV_SSH_KEYS` to be set appropriately.

#### Building an Image and Bundle

To build an image and an update bundle for a given system:

```shell
just build <system> [--without-compression]
```

Use `--without-compression` to speed up the build.

#### Upload an OTA Payload

To upload the update bundle as a Memfault OTA payload:

```shell
just upload <system>
```
