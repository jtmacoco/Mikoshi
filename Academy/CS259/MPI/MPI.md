**Source:** [[CS259]]
**Tags:** #mpi #parallel-computing
# Communicators
- In MPI  a **communicator** is a collection of processes that can send messages to each other
- `MPI_Init` creates a communicator consist of the process started by the user
- Communicator called `MPI_COMM_WORLD`
- `comm_sz` var is often used for the number of processes within the `MPI_COMM_WORLD`
[[CS259]]