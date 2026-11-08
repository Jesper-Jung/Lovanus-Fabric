# 🌌 Lovanus-Fabric

![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-blue.svg)
![Verilator](https://img.shields.io/badge/Simulator-Verilator_5+-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**Lovanus-Fabric** is a modern, lightweight AMBA (AHB-Lite/APB) interconnect and memory subsystem tailored for the **Lovanus-2 RISC-V Audio-Specific Processor**. 

Designed with modern hardware verification in mind, this repository provides not only synthesizable RTL but also a robust, **Verilator 5-driven verification environment** featuring random traffic generation and fully pipelined Bus Functional Models (BFMs).

## ✨ Key Features

* **High-Performance Bus Architecture:** Standard AMBA 3.0 AHB-Lite matrix and AHB-to-APB bridges with zero wait-state capability.
* **Flawless Pipelining:** Perfectly decoupled Address Phase (APH) and Data Phase (DPH) handling.
* **Modern DV Environment (No Icarus!):** Fully migrated to **Verilator 5**. Supports C++ binary compilation, X-propagation checks, and FST waveform dumping.
* **Robust Traffic Generator:** Custom SystemVerilog BFM that injects randomized burst transfers and wait states to rigorously stress-test the interconnect.
* **Cache Subsystem (WIP):** Instruction and Data cache modules optimized for DSP and audio workloads.

## 📂 Repository Structure

```text
lovanus-fabric/
├── rtl/                    # Synthesizable SystemVerilog RTL
│   ├── ahb/                # AHB Arbiter, Decoder, Multiplexer
│   ├── apb/                # AHB-to-APB Bridge
│   └── cache/              # I-Cache, D-Cache modules
├── dv/                     # Design Verification
│   ├── bfm/                # Advanced Traffic Generator & Slave memory models
│   └── tests/              # Top-level testbenches (e.g., tb_ahb_traffic_gen.sv)
├── sim/                    # Simulation & Build Environment
│   ├── include_file.f      # File compilation list
│   └── Makefile            # Modern Verilator 5 build script
└── docs/                   # Block diagrams and timing specifications


🛠️ Tech Stack & Tools
Design & Verification: SystemVerilog (IEEE 1800-2012)
Simulation: Verilator (v5.048+)
Waveform Viewer: GTKWave (FST format)
Environment: Tested on macOS Sequoia (Apple Silicon M2 Pro)

📝 Roadmap
[x] Basic AHB-Lite Master/Slave BFM modeling
[x] Pipelined read/write transaction support
[x] Verilator 5 CI/CD simulation environment setup
[ ] AHB-to-APB Bridge implementation
[ ] RISC-V 'A' (Atomic) extension bus protocol support
