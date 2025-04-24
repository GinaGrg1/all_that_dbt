def topologicalSort(items):

  nodes = {item["name"]: i for i, item in enumerate(items)}
  edges = defaultdict(list)
  in_degree = defaultdict(int)

  for item in items:
    name = item["name"]
    depends_on = item.get("depends_on", [])
    for dep in depends_on:
      edges[dep].append(name)
      in_degree[name] += 1

  to_visit = deque([node for node in nodes.keys() if in_degree[node] == 0])
  topo_sorted_idxs = []

  while to_visit:
    node = to_visit.popleft()
    topo_sorted_idxs.append(nodes[node])
    # print("visiting: ", node, "to_visit: ", to_visit)
    for parent in edges[node]:
      in_degree[parent] -= 1
      if in_degree[parent] == 0:
          # print("-- adding parent: ", parent)
          to_visit.append(parent)

  if len(topo_sorted_idxs) != len(nodes):
    raise ValueError("cycle detected")

  ordered_rules = [
      data[idx] for idx in topo_sorted_idxs
  ]

  return ordered_rules

topologicalSort(data)
