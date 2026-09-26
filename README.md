# Q-NEXUS
## Quantum-Assisted 5G/6G Network Intelligence & Optimization Platform

> **Model. Optimize. Reconfigure. Explain.**

Q-NEXUS is a real, functional engineering prototype and research platform that models 5G/6G radio access network (RAN) physics, constructs mathematical Quadratic Unconstrained Binary Optimization (QUBO) formulations of cellular interference and user-channel associations, and solves them via QAOA (Quantum Approximate Optimization Algorithm) on quantum simulators and hardware adapters.

---

## 1. System Architecture

```text
                 Q-NEXUS FRONTEND
            (React / TypeScript / Tailwind)
                       │
                       │ REST API (JSON)
                       ▼
                 FASTAPI BACKEND
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
 Network Engine   Optimization     Quantum Engine
        │              │              │
        ▼              ▼              ▼
 Channel Model     QUBO Builder     Qiskit / QAOA
 (3GPP TS 38.901) (Ising Mapping)   (Statevector / Aer)
        │              │              │
        └──────────────┼──────────────┘
                       ▼
                Evaluation Engine
          (Power Refinement & Re-Sim)
                       │
                       ▼
                 Experiment DB
                   (SQLite)
```

---

## 2. Key Features

- **True 3GPP RF Physics:** Log-distance path loss, thermal noise $N=kTB$, directional antenna beamforming, and mutual inter-cell interference summation in linear Watts.
- **Classical Baselines:** Real Round-Robin, Greedy SINR, and Load-Aware heuristic assignments.
- **Problem Decomposition:** Intelligently isolates congested cell clusters and prunes search space down to the quantum qubit budget.
- **QUBO Formulation Engine:** Rigorous penalty terms for single-association constraints $(\sum x - 1)^2$, co-channel collisions, and mutual cross-cell interference.
- **QAOA Quantum Solver:** Evaluates parameterized unitary ansatz $|\psi(\gamma, \beta)\rangle$ with classical variational optimization (COBYLA) and quantum state measurement sampling.
- **Classical Continuous Refinement:** Tunes base station discrete power levels (`[20, 24, 28, 32, 36, 40] dBm`) and steers beam azimuths towards connected user centroids.
- **Physical-Layer Re-Simulation:** Re-runs the entire network simulator with optimized parameters to verify genuine throughput, SINR, and energy gains.
- **Explainability Engine:** Translates numerical parameter shifts into human-interpretable technical rationales for every reconfigured user and cell site.
- **Persistent Experiment DB & Scientific Reports:** Stores runs with cryptographic configuration hashes and generates comprehensive Markdown reports.

---

## 3. Installation & Setup

### Prerequisites
- Python 3.10+ (Tested on Python 3.13)
- Node.js LTS (v20+) & npm (optional for Vite dev server)

### 1. Install Backend Dependencies
```bash
pip install -r backend/requirements.txt
```

### 2. Installing Qiskit
Qiskit is installed via pip:
```bash
pip install qiskit qiskit-aer
```

---

## 4. Running the Platform

### Start the Unified Backend & Platform Console
From the project root:
```bash
python -m uvicorn app.main:app --app-dir backend --host 0.0.0.0 --port 8000 --reload
```
Once started:
- **Interactive Web Platform & Digital Twin:** Open [http://localhost:8000/](http://localhost:8000/) in any browser.
- **Interactive OpenAPI Documentation:** Open [http://localhost:8000/docs](http://localhost:8000/docs).

### (Optional) Running Vite Frontend in Development Mode
```bash
cd frontend
npm install
npm run dev
```

---

## 5. Running the Automated Test Suite

Q-NEXUS includes comprehensive unit and integration tests covering physical equations, baseline solvers, QUBO generation, QAOA convergence, and end-to-end evaluation:

```bash
# Windows PowerShell
$env:PYTHONPATH="backend"
python -m pytest backend/tests -v
```

All 11 tests will execute and verify mathematical correctness.

---

## 6. Mathematical Model

### Path Loss Model
3GPP Log-distance path loss:
$$PL(d) = PL_0 + 10 \cdot n \cdot \log_{10}\left(\frac{d}{d_0}\right)$$
where $d_0 = 1.0\text{ m}$, $PL_0 = 20 \log_{10}\left(\frac{4\pi d_0 f}{c}\right)$, and $n = 3.5$.

### Received Power & Thermal Noise
$$P_r(\text{dBm}) = P_t(\text{dBm}) + G_t(\text{dBi}) + G_{beam}(\theta) - PL(d)$$
$$N = k \cdot T \cdot B \cdot F$$
where $k = 1.380649 \times 10^{-23}\text{ J/K}$, $T = 290\text{ K}$, $B = 20\text{ MHz}$, and $NF = 7.0\text{ dB}$.

### Co-Channel Interference & SINR
$$I_u = \sum_{b' \neq b^*, \text{channel}(b')=c_u} P_r(b' \to u) \quad \text{[Watts]}$$
$$\text{SINR}_u = \frac{P_r(b^* \to u)}{I_u + N}$$

### Shannon-Hartley Throughput
$$C_u = \eta \cdot B \cdot \log_2(1 + \text{SINR}_u) \quad [\text{Mbps}]$$
with 5G NR practical implementation efficiency $\eta = 0.75$.

---

## 7. QUBO Formulation

For binary decision variables $x(u,b,c) \in \{0, 1\}$ (user $u$ assigned to BS $b$ on channel $c$):

$$\min \quad x^T Q x = -\sum_i \text{Utility}_i x_i + A \sum_u \left(\sum_{b,c} x(u,b,c) - 1\right)^2 + B \sum_{b,c} \sum_{u_1 < u_2} x(u_1,b,c)x(u_2,b,c) + C \sum_{\text{cross-cell}} I_{ij} x_i x_j$$

---

## 8. Scientific Limitations & Reproducibility

> **Disclaimer:** Q-NEXUS is a research prototype for evaluating quantum-assisted approaches to wireless network optimization. Quantum advantage is not assumed. Performance depends on problem size, formulation, simulator characteristics, and classical baselines.

Every experiment is fully deterministic and reproducible via its `random_seed` and cryptographic configuration hash stored in the SQLite database.
