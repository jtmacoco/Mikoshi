- <span style="color:rgb(0, 176, 80)">CUDA is NVIDIA's parallel computing framework that enables developers to write programs that run on NVIDIA GPUs, leveraging thousands of cores for parallel processing</span>
- Each  CUDA thread has it's own stack
## GPU architecture
- GPU's are typically <span style="color:rgb(255, 0, 0)">SIMD</span>
- CUDA are composed of <span style="color:rgb(255, 0, 0)">Streaming Multiprocessors</span> (SMs)
	- SMs contain multiple CUDA cores allowing them to execute different operations
	- <span style="color:rgb(112, 48, 160)">Analogy:</span> Think of SMs as factories and CUDA cores are the works inside each factory. 
	- Note that each SM (Streaming Multiprocessor) follows a SIMT (Single Instruction, Multiple Threads) execution model, which is similar to SIMD (Single Instruction, Multiple Data). However, different SMs can execute different instructions independently, making the overall architecture somewhat similar to MIMD (Multiple Instruction, Multiple Data).
- Data paths are called <span style="color:rgb(255, 0, 0)">Streaming Processors</span>(SPs) AKA CUDA cores
- Nvidia uses <span style="color:rgb(255, 0, 0)">Single Instruction Multi Thread(SIMT) </span>instead of SIMD
- CUDA utilizes both the CPU and GPU
	- The CPU sets up the program such as preparing the program data, initializing the cuda kernel, etc.
	- CPU then sends copy of memory/data to the GPU often called a transfer
	- GPU then processes this data in parallel
	- Once GPU is finished doing it's parallel processing, then it transfers the result back to the CPU
- CUDA can't use gcc compiler it must use it's own nvcc, since it must compile and generate machine code for both the cpu processor and gpu processor
- <span style="color:rgb(0, 176, 80)">Host:</span> CPU
- <span style="color:rgb(0, 176, 80)">Device:</span> GPU

## Returning results from CUDA kernels 
- Always return type void
- Can't use C pass by reference because the addresses on the host are in most systems in valid on the device and vice versa

Grid
└── Block 0 ─┐
└── Block 1 ─┼──> scheduled to SM 0
└── Block 2 ─┘

SM 0
└── Warp 0 ──> Threads 0-31 → run on SPs
└── Warp 1 ──> Threads 32-63 → run on SPs
**1 block per SM** _can_ be true, **but not always**.
- **An SM can run multiple blocks at the same time** (if there's enough resources like shared memory and registers).
    
- **If a block is big/heavy**, then maybe only 1 block fits on that SM.

- Your GPU has **64KB shared memory per SM**.
    
- Each block uses **16KB shared memory**.
    
- So: `64KB / 16KB = 4` → **4 blocks can fit on that SM at the same time**.
**Each block goes to one SM**, and **each SM can run 1 or more blocks**, depending on how "heavy" the blocks are.

[[CS259]]
