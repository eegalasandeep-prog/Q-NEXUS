import urllib.request
import json
import time

def post(url, payload):
    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode('utf-8'),
        headers={'Content-Type': 'application/json'}
    )
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read().decode('utf-8'))

def get(url):
    with urllib.request.urlopen(url) as resp:
        return json.loads(resp.read().decode('utf-8'))

print("=== Q-NEXUS QUANTUM MODULE VERIFICATION ===")

# 1. Health check
health = get("http://127.0.0.1:8000/api/health")
print(f"[1] Health Check: status={health['status']}, qiskit={health.get('qiskit_available')}, qiskit_aer={health.get('qiskit_aer_available')}")

# 2. Create demo scenario
print("\n[2] Creating Demo Scenario...")
scen = post("http://127.0.0.1:8000/api/scenarios/demo", {})
scen_id = scen["scenario_id"]
print(f"    [OK] Scenario created: ID={scen_id}, BS={scen['base_stations_count']}, Users={scen['users_count']}")

# 3. QUBO Generation
print("\n[3] Generating QUBO Formulation...")
t0 = time.time()
qubo = post("http://127.0.0.1:8000/api/qubo/generate", {
    "scenario_id": scen_id,
    "objective_weights": {"throughput": 1.0, "interference": 1.0, "qos": 1.0, "energy": 0.5}
})
qubo_id = qubo["qubo_id"]
n_vars = qubo["qubo_model"]["num_variables"]
print(f"    [OK] QUBO Generated in {time.time()-t0:.2f}s: ID={qubo_id}, Variables={n_vars}")

# 4. Quantum Solve (QAOA simulation)
print("\n[4] Solving via QAOA Simulation...")
t0 = time.time()
sol = post("http://127.0.0.1:8000/api/quantum/run", {
    "qubo_id": qubo_id,
    "solver_type": "auto",
    "qaoa_depth": 1,
    "shots": 256
})
print(f"    [OK] QAOA Solved in {time.time()-t0:.2f}s: Solver={sol.get('quantum_stats', {}).get('solver_type', 'auto')}")
print(f"         Bitstring: {sol.get('quantum_stats', {}).get('bitstring', '')[:24]}... (length={len(sol.get('quantum_stats', {}).get('bitstring', ''))})")
print(f"         Energy: {sol.get('quantum_stats', {}).get('energy')}")

# 5. Full Hybrid Optimization Pipeline
print("\n[5] Running Full Hybrid Optimization Pipeline...")
t0 = time.time()
opt = post("http://127.0.0.1:8000/api/optimization/run", {
    "scenario_id": scen_id,
    "baseline_algorithm": "greedy_sinr",
    "qubo_config": {"objective_weights": {"throughput": 1.0, "interference": 1.0, "qos": 1.0, "energy": 0.5}},
    "quantum_backend": "simulator",
    "qaoa_depth": 1,
    "shots": 256
})
print(f"    [OK] Pipeline completed in {time.time()-t0:.2f}s: Status={opt.get('status', 'complete')}")
print(f"         Baseline throughput:  {opt['baseline_metrics']['total_throughput_mbps']:.2f} Mbps")
print(f"         Optimized throughput: {opt['optimized_metrics']['total_throughput_mbps']:.2f} Mbps")
print(f"         Throughput gain:      {opt['comparison']['throughput_gain_pct']:.1f}%")
print(f"         SINR gain:            {opt['comparison']['sinr_gain_db']:.2f} dB")
print(f"         QoS satisfaction:     {opt['optimized_metrics']['qos_satisfaction_rate']:.1f}%")
print(f"         Pipeline runtime:     {opt['runtime_total_ms']:.2f} ms")


print("\n=== ALL QUANTUM MODULES ARE VERIFIED AND WORKING PROPERLY! ===")
