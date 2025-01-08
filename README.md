# AHS Tutorial Docker

## Instructions

First, clone the `ahs-tutorial` repository:

```bash
git clone git@github.com:pku-liang/ahs-tutorial.git repos
cd repos
git submodule update --init --recursive
cd ..
```

Then, build the docker image:

> [!NOTE]
> If you don't need proxy setting for docker build, please comment out line 32 in `Dockerfile`.

```bash
chmod +x run.sh
./run.sh build -i ahs-docker
```

Then, run the container:

```bash
./run.sh run -i ahs-docker -c ahs-docker -v mount.json
docker attach ahs-docker
```

And, in the container, you can run the following commands to install the dependencies:

```bash
cd /root/repos
chmod 777 ./install.sh
./install.sh
```

## Docker Utilities

Give `run.sh` executable permission:

Before running, make sure proxy settings are good for Docker access.


```bash
chmod +x run.sh
```

For usage, run:

```bash
./run.sh <command> [options]
```

Pull the base image, run:

```bash
./run.sh pull
```

Build the image, run:

```bash
./run.sh build -i hw-env
```

Run the container, run:

```bash
./run.sh run -i hw-env -c hw-env -v mount.json
```

The mount information is specified in `mount.json` in JSON format.

If you need proxy inside docker, put proxy settings in `Dockerfile.proxy`, and edit `Dockerfile` to include it (line 27).
