# Commit Messages

Use conventional commits with a GitMoji icon. Format:

```
<type>: <gitmoji> <description under 50 chars>
```

- One-liner only, no detailed description body
- The gitmoji goes after the colon, separated by a space on each side
- Keep the entire message under 50 characters

Examples:
- `feat: ✨ Add user authentication`
- `fix: 🐛 Fix login redirect loop`
- `chore: 🎉 Initial project setup`

# Shell Commands

Run all shell commands via `direnv exec .` to pick up environment variables (e.g. KUBECONFIG):

```bash
direnv exec . kubectl get pods
direnv exec . ansible-playbook reef.yaml
```
