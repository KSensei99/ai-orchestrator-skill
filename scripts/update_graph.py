import json
import os
import argparse
import re

def main():
    parser = argparse.ArgumentParser(description="Update the graphify knowledge graph with new/updated skill nodes.")
    parser.add_argument("--skill", required=True, help="Name of the skill (e.g., ab-test-setup)")
    parser.add_argument("--category", required=True, help="ID of the parent category node in graph.json (e.g., knowledge_skills_testing_quality_assurance)")
    parser.add_argument("--description", required=True, help="Core capability / what the skill does best")
    parser.add_argument("--graph", help="Path to graph.json (defaults to graphify-out/graph.json)")
    args = parser.parse_args()

    # Determine graph path
    graph_path = args.graph
    if not graph_path:
        # Default relative locations
        possible_paths = [
            os.path.join("knowledge", "graphify-out", "graph.json"),
            os.path.join("graphify-out", "graph.json"),
            "graph.json"
        ]
        for path in possible_paths:
            if os.path.exists(path):
                graph_path = path
                break
        if not graph_path:
            graph_path = possible_paths[0] # fallback default

    if not os.path.exists(graph_path):
        print(f"Error: Graph file not found. Please specify --graph path.")
        return

    try:
        with open(graph_path, "r", encoding="utf-8") as f:
            graph = json.load(f)
    except Exception as e:
        print(f"Error reading graph file {graph_path}: {e}")
        return

    # Normalize skill name for ID
    safe_name = re.sub(r'[^a-zA-Z0-9_]', '_', args.skill.replace('-', '_')).lower()
    node_id = f"skill_{safe_name}"
    
    # 1. Update or create the node
    nodes = graph.get("nodes", [])
    node_index = -1
    for i, node in enumerate(nodes):
        if node.get("id") == node_id:
            node_index = i
            break

    skill_source_file_relative = f"config/skills/{args.skill}/SKILL.md"

    new_node = {
        "id": node_id,
        "label": args.skill,
        "file_type": "skill",
        "source_file": skill_source_file_relative,
        "what_it_does_best": args.description,
        "community": 0,
        "norm_label": args.skill.replace('-', ' ')
    }

    if node_index != -1:
        nodes[node_index].update({
            "what_it_does_best": args.description
        })
        print(f"Updated existing node: {node_id}")
    else:
        nodes.append(new_node)
        print(f"Added new node: {node_id}")
    
    graph["nodes"] = nodes

    # 2. Update or create the link (relation) to parent category
    links = graph.get("links", [])
    link_exists = False
    for link in links:
        if link.get("source") == node_id and link.get("target") == args.category:
            link_exists = True
            break
            
    if not link_exists:
        new_link = {
            "relation": "belongs_to",
            "confidence": "UPDATED",
            "confidence_score": 1.0,
            "weight": 1.0,
            "source": node_id,
            "target": args.category
        }
        links.append(new_link)
        print(f"Added link from {node_id} to {args.category}")
    else:
        print(f"Link from {node_id} to {args.category} already exists")

    graph["links"] = links

    # 3. If there is a hyperedge for skills indexing, add the skill to it
    hyperedges = graph.get("graph", {}).get("hyperedges", [])
    hyperedge_index = -1
    for i, edge in enumerate(hyperedges):
        if edge.get("id") == "hyperedge_skills_indexing":
            hyperedge_index = i
            break

    if hyperedge_index != -1:
        edge_nodes = hyperedges[hyperedge_index].get("nodes", [])
        if node_id not in edge_nodes:
            edge_nodes.append(node_id)
            hyperedges[hyperedge_index]["nodes"] = edge_nodes
            print(f"Added node {node_id} to hyperedge_skills_indexing")
            
    # Do the same for top-level hyperedges (graph.hyperedges) if it exists
    top_hyperedges = graph.get("hyperedges", [])
    top_hyperedge_index = -1
    for i, edge in enumerate(top_hyperedges):
        if edge.get("id") == "hyperedge_skills_indexing":
            top_hyperedge_index = i
            break

    if top_hyperedge_index != -1:
        top_edge_nodes = top_hyperedges[top_hyperedge_index].get("nodes", [])
        if node_id not in top_edge_nodes:
            top_edge_nodes.append(node_id)
            top_hyperedges[top_hyperedge_index]["nodes"] = top_edge_nodes
            print(f"Added node {node_id} to top-level hyperedge_skills_indexing")

    # Save graph atomically
    temp_path = graph_path + ".tmp"
    try:
        with open(temp_path, "w", encoding="utf-8") as f:
            json.dump(graph, f, indent=2)
        os.replace(temp_path, graph_path)
        print(f"Successfully saved graph to {graph_path}")
    except Exception as e:
        if os.path.exists(temp_path):
            os.remove(temp_path)
        print(f"Error writing graph file: {e}")

if __name__ == "__main__":
    main()
