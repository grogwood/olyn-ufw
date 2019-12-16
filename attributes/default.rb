# Firewall port rules (built inside the wrapper recipe)
override['firewall']['rules'] = []

# UFW wrapper overrides
override[:firewall][:allow_ssh] = false