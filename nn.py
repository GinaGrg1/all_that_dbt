def order_rules_by_dependency(unordered_rules: list[dict]) -> list[dict]:
    """Orders dictionary items by required dependencies.
    Creates a new list of dictionaries containing the same metadata rules
    supplied in the unordered_rules parameter, but reordered to ensure that
    any rule which is a dependency of another occurs in the list prior to encountering
    the dependency. This makes sure that any rules which are required to be completed
    are done so in the correct order.

    Args:
        unordered_rules (list[dict]): List of rules retrievied from the YAML metadata.
    
    Returns:
        ordered_rules (list[dict]): List containing the same dictionaries supplied in
                                    unordered_rules, but in a different order to make sure
                                    rules required by later rules have already completed.
    """
        
    ordered_rules = []
    
    # Repeatedly iterate the unordered rules removing them post-processing until the list is empty
    while unordered_rules:
        for index, rule in enumerate(unordered_rules):
            # If the rule doesn't depend on another rule, or if it does but that rule is already in ordered_rules
            #  then append the rule to ordered_rules and remove it from unordered_rules
            if "depends_on" not in rule or any(dep_rule["name"] == rule["depends_on"] for dep_rule in ordered_rules):

                ordered_rules.append(rule)
                unordered_rules.pop(index)
                
                break


    return ordered_rules
