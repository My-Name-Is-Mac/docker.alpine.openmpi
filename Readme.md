## docker.alpine.openmpi

With the code in this repository, you can build a Docker container that provides 
the OpenMPI runtime and tools along with various supporting libaries, 
including the MPI4Py Python bindings. The container also runs an OpenSSH server
so that multiple containers can be linked together and used via `mpirun`.


## MPI Container Cluster with `docker compose`

While containers can in principle be started manually via `docker run`, we suggest that your use 
[Docker Compose](https://docs.docker.com/compose/), a simple command-line tool 
to define and run multi-container applications. We provide a sample `docker-compose.yml` file in the repository:

```
services:
  mpi_head:
    image: .
    ports: 
     - "22"
    links: 
     - mpi_node

  mpi_node: 
    image: .

```

The file defines an `mpi_head` and an `mpi_node`. Both containers run the same `openmpi` image. 
The only difference is, that the `mpi_head` container exposes its SSH server to 
the host system, so you can log into it to start your MPI applications.


## Usage

### Docker
The following command, run from the repository's directory, will start one `mpi_head` container and three `mpi_node` containers: 

```
$> docker compose up --scale mpi_node=2
```
Once all containers are running, you can login into the `mpi_head` node and start MPI jobs with `mpirun`. Alternatively, you can execute a one-shot command on that container with the `docker compose exec` syntax, as follows: 

    $> docker compose exec --privileged mpi_head mpirun --allow-run-as-root -n 2 python /root/mpi4py_benchmarks/all_tests.py

Breaking the above command down:

1. Execute command on node `mpi_head`
2. Run on 2 MPI ranks
3. Command to run (NB: the Python script needs to import MPI bindings)

### Podman
The following command, run from the repository's directory, will start one `mpi_head` container and three `mpi_node` containers: 

```
$> docker-compose -f docker-compose-podman.yml up --scale mpi_head=1 --scale mpi_node=2
```
* Run twice these commands if got error builtkit for first time

Once all containers are running, you can login into the `mpi_head` node and start MPI jobs with `mpirun`. Alternatively, you can execute a one-shot command on that container with the `docker compose exec` syntax, as follows: 

    $> docker-compose -f docker-compose-podman.yml exec --privileged mpi_head mpirun --allow-run-as-root -n 2 python /root/mpi4py_benchmarks/all_tests.py


## Credits

This repository draws from work on https://github.com/dispel4py/ by O. Weidner and R. Filgueira 
